function map {
  PARAMETER list.
  PARAMETER fn.

  local new IS LIST().
  for item in list {
    new:add(fn:call(item)).
  }
  return new.
}

function filter {
  PARAMETER list.
  PARAMETER fn.

  local new IS LIST().
  for item in list {
    if fn:call(item) {
      new:add(item).
    }
  }
  return new.
}
