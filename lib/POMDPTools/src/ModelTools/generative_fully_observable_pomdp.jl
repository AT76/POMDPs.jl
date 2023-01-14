"""
    GenerativeFullyObservablePOMDP(mdp)
Turn an `MDP` `mdp` defined by a generative model into a `POMDP` where the observations are the states of the MDP.
"""
struct GenerativeFullyObservablePOMDP{M,S,A} <: POMDP{S,A,S}
    mdp::M
end

function GenerativeFullyObservablePOMDP(m::MDP)
    return GenerativeFullyObservablePOMDP{typeof(m), statetype(m), actiontype(m)}(m)
end

mdptype(::Type{GenerativeFullyObservablePOMDP{M,S,A}}) where {M,S,A} = M

POMDPs.observations(pomdp::GenerativeFullyObservablePOMDP) = states(pomdp.mdp)
POMDPs.obsindex(pomdp::GenerativeFullyObservablePOMDP{S, A}, o::S) where {S, A} = stateindex(pomdp.mdp, o)

POMDPs.convert_o(T::Type{V}, o, pomdp::GenerativeFullyObservablePOMDP) where {V<:AbstractArray} = convert_s(T, s, pomdp.mdp)
POMDPs.convert_o(T::Type{S}, vec::V, pomdp::GenerativeFullyObservablePOMDP) where {S,V<:AbstractArray} = convert_s(T, vec, pomdp.mdp)

function POMDPs.observation(pomdp::GenerativeFullyObservablePOMDP, a, sp)
    return Deterministic(sp)
end

function POMDPs.observation(pomdp::GenerativeFullyObservablePOMDP, s, a, sp)
    return Deterministic(sp)
end

# inherit other function from the MDP type

POMDPs.states(pomdp::GenerativeFullyObservablePOMDP) = states(pomdp.mdp)
POMDPs.actions(pomdp::GenerativeFullyObservablePOMDP) = actions(pomdp.mdp)
POMDPs.gen(pomdp::GenerativeFullyObservablePOMDP, s, a, rng) = gen(pomdp.mdp, s, a, rng)
POMDPs.isterminal(pomdp::GenerativeFullyObservablePOMDP, s) = isterminal(pomdp.mdp, s)
POMDPs.discount(pomdp::GenerativeFullyObservablePOMDP) = discount(pomdp.mdp)
POMDPs.stateindex(pomdp::GenerativeFullyObservablePOMDP, s) = stateindex(pomdp.mdp, s)
POMDPs.actionindex(pomdp::GenerativeFullyObservablePOMDP, a) = actionindex(pomdp.mdp, a)
POMDPs.convert_s(T::Type{V}, s, pomdp::GenerativeFullyObservablePOMDP) where V<:AbstractArray = convert_s(T, s, pomdp.mdp)
POMDPs.convert_s(T::Type{S}, vec::V, pomdp::GenerativeFullyObservablePOMDP) where {S,V<:AbstractArray} = convert_s(T, vec, pomdp.mdp)
POMDPs.convert_a(T::Type{V}, a, pomdp::GenerativeFullyObservablePOMDP) where V<:AbstractArray = convert_a(T, a, pomdp.mdp)
POMDPs.convert_a(T::Type{A}, vec::V, pomdp::GenerativeFullyObservablePOMDP) where {A,V<:AbstractArray} = convert_a(T, vec, pomdp.mdp)
POMDPs.initialstate(m::GenerativeFullyObservablePOMDP) = initialstate(m.mdp)
POMDPs.initialobs(m::GenerativeFullyObservablePOMDP, s) = Deterministic(s)