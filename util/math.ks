function signum {
  parameter number.

  if number > 0 {
    return 1.
  } else {
    return -1.
  }
}

function semi_equal {
  parameter a.
  parameter b.
  parameter difference.
  return abs(a - b) <= difference.
}

function clamp {
  parameter number.
  parameter lower_bound.
  parameter upper_bound.
  return max(min(number, upper_bound), lower_bound).
}
