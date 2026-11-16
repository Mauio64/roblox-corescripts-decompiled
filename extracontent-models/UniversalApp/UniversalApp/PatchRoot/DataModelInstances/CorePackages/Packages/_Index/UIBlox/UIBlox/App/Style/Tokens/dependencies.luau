local parent = script.Parent.Parent
local parent2 = parent.Parent.Parent.Parent
local RbxDesignFoundationsV1 = require(parent2.RbxDesignFoundationsV1)
local Constants = require(parent.Constants)
local Dependencies = {}

function Dependencies.GetTokenGenerators(value)
	local lower = value:lower()

	if lower == Constants.ThemeName.Dark:lower() then
		return RbxDesignFoundationsV1.tokens.Common.Builder.Dark
	end

	if lower == Constants.ThemeName.Light:lower() then
		return RbxDesignFoundationsV1.tokens.Common.Builder.Light
	end

	return nil
end

function Dependencies.GetFoundationTokens(value)
	local RbxDesignFoundationsV4 = require(parent2.RbxDesignFoundationsV4)
	local v = RbxDesignFoundationsV4.themes[RbxDesignFoundationsV4.Theme.Default]()
	local lower = value:lower()

	if lower == Constants.ThemeName.Dark:lower() then
		return v.Dark
	end

	if lower == Constants.ThemeName.Light:lower() then
		return v.Light
	end

	return nil
end

return Dependencies
