TRE_PROTOCOL_VERSION <- "1.0.0"

compact_null_fields <- function(x) {
  if (length(x) == 0L) {
    return(list())
  }
  x[!vapply(x, is.null, logical(1))]
}

merge_request_body <- function(auto_fields = list(), dot_fields = list(), explicit_body = NULL) {
  if (!is.null(explicit_body)) {
    return(explicit_body)
  }

  body <- compact_null_fields(auto_fields)
  dots <- compact_null_fields(dot_fields)
  if (length(dots) == 0L) {
    return(body)
  }

  named <- names(dots)
  if (is.null(named)) {
    return(c(body, dots))
  }

  for (i in seq_along(dots)) {
    key <- names(dots)[[i]]
    if (is.null(key) || !nzchar(key)) {
      next
    }
    body[[key]] <- dots[[i]]
  }
  body
}

new_tre_protocol_request <- function(kind, body = list(), protocol_version = TRE_PROTOCOL_VERSION) {
  list(
    protocol_version = protocol_version,
    kind = kind,
    body = body %||% list()
  )
}

tre_result_ok <- function(envelope) {
  ok <- envelope$ok
  if (is.logical(ok) && length(ok) == 1L) {
    return(isTRUE(ok))
  }
  is.null(envelope$error) && is.null(envelope$failure)
}

tre_extract_data <- function(envelope) {
  for (key in c("data", "result", "output", "body")) {
    if (!is.null(envelope[[key]])) {
      return(envelope[[key]])
    }
  }
  envelope
}

tre_normalize_output <- function(result, output_label = NULL, status_and_purpose = NULL, function_name = NULL) {
  envelope <- result$envelope %||% list()
  if (!tre_result_ok(envelope)) {
    failure <- protocol_failure_summary(envelope)
    abort_ahri_tre(
      sprintf("%s failed: %s", function_name %||% "TRE command", failure$message),
      class = "ahri_tre_protocol_error"
    )
  }

  structure(
    list(
      function_name = function_name,
      output_label = output_label,
      status_and_purpose = status_and_purpose,
      data = tre_extract_data(envelope),
      envelope = envelope,
      payloads = result$payloads %||% list()
    ),
    class = "ahri_tre_wrapper_result"
  )
}

tre_command_call <- function(
  client,
  kind,
  ...,
  .auto_fields = list(),
  .body = NULL,
  .protocol_version = TRE_PROTOCOL_VERSION,
  .output_label = NULL,
  .status_and_purpose = NULL,
  .function_name = NULL
) {
  body <- merge_request_body(
    auto_fields = .auto_fields,
    dot_fields = list(...),
    explicit_body = .body
  )

  result <- execute_json(
    client = client,
    request = new_tre_protocol_request(
      kind = kind,
      body = body,
      protocol_version = .protocol_version
    )
  )

  tre_normalize_output(
    result = result,
    output_label = .output_label,
    status_and_purpose = .status_and_purpose,
    function_name = .function_name
  )
}


