local dependencies = require(script.dependencies)
local parent = script.Parent.Parent.Parent

local getTokenGenerators = dependencies.GetTokenGenerators
local getFoundationTokens = dependencies.GetFoundationTokens

local UIBloxConfig = require(parent.UIBloxConfig)
local Types = require(script.Types)
local Constants = require(script.Parent.Constants)

local function getPlatformScale(p, p2: number?) -- 2 equivalent calls inferred from this helper
	if UIBloxConfig.disableTokenScaling then
		return 1
	end

	local v = math.clamp(p2 == nil and 1 or p2, 0, 1e999)

	return (p == Constants.DeviceType.Console and 1.5 or 1) * v
end

local Tokens = {}

function Tokens.getTokens(p, p2, p3: number?)
	local v = getTokenGenerators(p2) or getTokenGenerators(Constants.DefaultThemeName)
	local platformScale = getPlatformScale(p, p3) -- inferred equivalent call
	return {
		Global = v.Global(platformScale),
		Semantic = v.Semantic(platformScale),
		Component = v.Component(platformScale)
	}
end

Tokens.Types = Types

function Tokens.getFoundationTokens(p, p2, p3: number?)
	return (getFoundationTokens(p2) or getFoundationTokens(Constants.DefaultThemeName))(getPlatformScale(p, p3)) -- inferred equivalent call
end

function Tokens.getFoundationTokensDefaultScale(p)
	return (getFoundationTokens(p) or getFoundationTokens(Constants.DefaultThemeName))(1)
end

Tokens.Mappers = require(script.mappers)
return Tokens
