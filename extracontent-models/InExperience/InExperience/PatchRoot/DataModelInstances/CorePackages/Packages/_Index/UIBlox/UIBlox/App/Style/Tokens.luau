local dependencies = require(script.dependencies)
local ParentParent = script.Parent.Parent.Parent
local ParentParentParent = ParentParent.Parent
local t = require(ParentParentParent.t)
local GetTokenGenerators = dependencies.GetTokenGenerators
local Validators = dependencies.SchemaPackage.Validators
local GetFoundationTokens = dependencies.GetFoundationTokens
local UIBloxConfig = require(ParentParent.UIBloxConfig)
local Types = require(script.Types)
local Constants = require(script.Parent.Constants)

local function getPlatformScale(p1, n1: number?) -- line: 19
	-- upvalues: UIBloxConfig (copy), Constants (copy)
	if UIBloxConfig.disableTokenScaling then
		return 1
	end

	if n1 == nil then
		n1 = 1
	end

	local v14 = math.clamp(n1, 0, 1e999)
	local n2 = 1

	if p1 == Constants.DeviceType.Console then
		n2 = 1.5
	end

	return n2 * v14
end

return {
	getTokens = function(p2, p3, n3: number?) -- line: 39
		-- upvalues: GetTokenGenerators (copy), Constants (copy), UIBloxConfig (copy)
		local v19 = GetTokenGenerators(p3) or GetTokenGenerators(Constants.DefaultThemeName)
		local n4

		if UIBloxConfig.disableTokenScaling then
			n4 = 1
		else
			if n3 == nil then
				n3 = 1
			end

			local v21 = math.clamp(n3, 0, 1e999)
			local n5 = 1

			if p2 == Constants.DeviceType.Console then
				n5 = 1.5
			end

			n4 = n5 * v21
		end

		return {
			Global = require(v19.Global)(n4),
			Semantic = require(v19.Semantic)(n4),
			Component = require(v19.Component)(n4)
		}
	end,
	validateTokens = t.interface({
		Global = t.strictInterface(Validators.Global),
		Semantic = t.strictInterface(Validators.Semantic),
		Component = t.strictInterface(Validators.Component)
	}),
	Types = Types,
	getFoundationTokens = function(p4, p5, n6: number?) -- line: 55
		-- upvalues: GetFoundationTokens (copy), Constants (copy), UIBloxConfig (copy)
		local v26 = GetFoundationTokens(p5) or GetFoundationTokens(Constants.DefaultThemeName)
		local n7

		if UIBloxConfig.disableTokenScaling then
			n7 = 1
		else
			if n6 == nil then
				n6 = 1
			end

			local v28 = math.clamp(n6, 0, 1e999)
			local n8 = 1

			if p4 == Constants.DeviceType.Console then
				n8 = 1.5
			end

			n7 = n8 * v28
		end

		return v26(n7)
	end,
	getFoundationTokensDefaultScale = function(p6) -- line: 65
		-- upvalues: GetFoundationTokens (copy), Constants (copy)
		return (GetFoundationTokens(p6) or GetFoundationTokens(Constants.DefaultThemeName))(1)
	end,
	Mappers = require(script.mappers)
}
