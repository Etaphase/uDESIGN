#promoteFSS.jl - takes a Utype object and promotes its FSS across the board.

function promoteFSS{ESS,FSS}(v::Utype{ESS,FSS})
  T = Utype{ESS,FSS+1}
  U = Unum{ESS,FSS+1}
  if isa(v.val, Unum)
    T(U(v.val))
  else
    T(Ubound(U(v.val.lower), U(v.val.upper)))
  end
end

@generated function isterminal_prev{ESS,FSS}(v::Utype{ESS,FSS})
  (FSS == 0) && return :(throw(ArgumentError("")))
  target_fsize = max_fsize(FSS - 1)
  quote
    if isa(v.val, Unum)
      isexact(v.val) && return true
      return v.val.fsize >= $target_fsize
    else
      exp_upper = decode_exp(v.val.upper)
      exp_lower = decode_exp(v.val.lower)

      #Case 1:  values straddle zero.
      # make sure that both values are small subnormals
      if is_positive(v.val.upper) != is_positive(v.val.lower)
        v.val.upper.esize == max_esize(ESS) || return false
        v.val.lower.esize == max_esize(ESS) || return false
        is_exp_zero(v.val.upper) || return false
        is_exp_zero(v.val.lower) || return false
        is_frac_zero(v.val.upper) || return false
        is_frac_zero(v.val.lower) || return false

        v.val.upper.fsize > $target_fsize || return false
        v.val.lower.fsize > $target_fsize || return false
        return true
      end

      #Case 2:  top bound is not in the same exponent
      #as bottom bound.  Break into positive and negative cases.
      if (exp_upper != exp_lower)
        if is_positive(v.val.upper)
          (exp_upper > exp_lower + 1) && return false
        else
          (exp_lower > exp_upper + 1) && return false
        end
      end

    end
  end
end
