"""
Polynomial mutation as presented in the paper:
    Deb and Deb (2012), "Analyzing Mutation Schemes for Real-Parameter Genetic Algorithms"
"""
immutable PolynomialMutation{SS<:SearchSpace} <: GibbsMutationOperator
    ss::SS
    η::Float64

    (::Type{PolynomialMutation}){SS<:SearchSpace}(ss::SS, η = 50.0) = new{SS}(ss, η)
    (::Type{PolynomialMutation}){SS<:SearchSpace}(ss::SS, options::Parameters) =
        new{SS}(ss, options[:PM_η])
end

"""
Default parameters for `PolynomialMutation`.
"""
const PM_DefaultOptions = ParamsDict(
    :PM_η => 50.0,
)

function apply(m::PolynomialMutation, v::Number, dim::Int, target_index::Int)
    u = 2.0*rand()
    if u <= 1.0
        ΔL = u^(1.0/(1.0+m.η)) - 1.0
        return (v + ΔL * (v - mins(m.ss)[dim]))
    else
        ΔR = 1.0 - (2.0-u)^(1.0/(1.0+m.η))
        return (v + ΔR * (maxs(m.ss)[dim] - v))
    end
end
