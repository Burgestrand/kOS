function map {
  PARAMETER list.
  PARAMETER fn.

  local out IS LIST().
  for item in list {
    out:add(fn:call(item)).
  }
  return out.
}

function filter {
  PARAMETER list.
  PARAMETER fn.

  local out IS LIST().
  for item in list {
    if fn:call(item) {
      out:add(item).
    }
  }
  return out.
}

function reduce {
  PARAMETER list.
  PARAMETER initial.
  PARAMETER fn.

  local out IS initial.
  for item in list {
    SET out TO fn:call(out, item).
  }
  return out.
}
