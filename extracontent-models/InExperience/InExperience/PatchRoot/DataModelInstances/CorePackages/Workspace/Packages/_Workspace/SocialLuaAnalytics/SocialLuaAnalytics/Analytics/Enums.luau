local Contexts = require(script.Contexts)
local Sources = require(script.Sources)
local PresenceTypes = require(script.PresenceTypes)
local SubPages = require(script.SubPages)
local FriendStatuses = require(script.FriendStatuses)
local EventTypes = require(script.EventTypes)
local Pages = require(script.Pages)
local RecommendationContextTypes = require(script.RecommendationContextTypes)
local ContextualInfoTypes = require(script.ContextualInfoTypes)
local DiagEventTypes = require(script.DiagEventTypes)
local PlatformSpecificity = require(script.PlatformSpecificity)
local LoadingStages = require(script.LoadingStages)
local EntityTypes = require(script.EntityTypes)

return {
	Contexts = Contexts,
	Sources = Sources,
	EventTypes = EventTypes,
	FriendStatuses = FriendStatuses,
	PresenceTypes = PresenceTypes,
	SubPages = SubPages,
	Pages = Pages,
	RecommendationContextTypes = RecommendationContextTypes,
	ContextualInfoTypes = ContextualInfoTypes,
	DiagEventTypes = DiagEventTypes,
	PlatformSpecificity = PlatformSpecificity,
	LoadingStages = LoadingStages,
	SupportedTelemetryBackends = require(script.SupportedTelemetryBackends),
	EntityTypes = EntityTypes
}
