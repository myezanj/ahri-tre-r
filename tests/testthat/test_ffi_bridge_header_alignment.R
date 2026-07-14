test_that("bridge symbols are present in staged runtime header", {
  runtime_root <- Sys.getenv("AHRI_TRE_RUNTIME_ROOT", unset = "")
  testthat::skip_if(!nzchar(runtime_root), "AHRI_TRE_RUNTIME_ROOT is not set")

  header_path <- file.path(runtime_root, "include", "ahri_tre_ffi_c.h")
  bridge_path <- file.path(getwd(), "src", "ffi_bridge.c")

  testthat::skip_if_not(file.exists(header_path), "runtime C header is not available")
  testthat::skip_if_not(file.exists(bridge_path), "bridge source file is not available")

  bridge_lines <- readLines(bridge_path, warn = FALSE)
  symbol_lines <- grep('symbol\\(handle, "[^"]+"\\)', bridge_lines, value = TRUE)
  symbols <- unique(gsub('.*symbol\\(handle, "([^"]+)"\\).*', '\\1', symbol_lines))

  header_text <- paste(readLines(header_path, warn = FALSE), collapse = "\n")
  missing <- symbols[!vapply(symbols, function(name) {
    grepl(paste0("\\b", name, "\\b"), header_text)
  }, logical(1))]

  testthat::expect_length(
    missing,
    0L,
    info = paste("missing symbols in", header_path, ":", paste(missing, collapse = ", "))
  )
})
