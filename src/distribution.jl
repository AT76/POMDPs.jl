#############################
# Interface for distributions
#############################

"""
    rand{T}(rng::AbstractRNG, d::Any)

Return a random element from distribution or space `d`.

If `d` is a state or transition distribution, the sample will be a state; if `d` is an action distribution, the sample will be an action or if `d` is an observation distribution, the sample will be an observation.
"""
Base.rand

"""
    pdf(d::Any, x::Any)

Evaluate the probability density of distribution `d` at sample `x`.
"""
function pdf end # maybe eventually this should be Distributions.pdf

"""
    mode(d::Any)

Return the most likely value in a distribution d.
"""
function mode end

"""
    mean(d::Any)

Return the mean of a distribution d.
"""
Statistics.mean

"""
    iterator(d::Any)

Return an iterable object (array or custom iterator) that iterates over possible values of distribution `d`. Values with zero probability may be skipped.

Note: calling iterator to iterate over *spaces* is deprecated; it should only be used for distributions.
"""
function iterator end

# @generated function iterator(x::Any)
#     @warn("POMDPs.iterator(x) is deprecated. Simply iterate over the space or distribution directly.")
#     return :(x)
# end

"""
    sampletype(T::Type)
    sampletype(d::Any) = sampletype(typeof(d))

Return the type of objects that are sampled from a distribution or space `d` when `rand(rng, d)` is called.

The distribution writer should implement the `sampletype(::Type)` method for the distribution type, then the function can be called for that type or for objects of that type (i.e. the `sampletype(d::Any) = sampletype(typeof(d))` default is provided).
"""
function sampletype end

sampletype(d::Any) = sampletype(typeof(d))
sampletype(t::Type) = throw(MethodError(sampletype, (t,)))

implemented(f::typeof(sampletype), TT::Type{Tuple{T}}) where T<:Type = hasmethod(f, TT) && which(f, TT).module != POMDPs
implemented(f::typeof(sampletype), ::Type{Tuple{T}}) where T = implemented(f, Tuple{Type{T}})
