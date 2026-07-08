local ParentParent = script.Parent.Parent
local ParentParent2 = ParentParent.Parent.Parent.Parent
local t = require(ParentParent2.t)
local RbxDesignFoundations = require(ParentParent2.RbxDesignFoundations)
local Constants = require(ParentParent.Constants)

local function getThemePackageIndex(p1) -- line: 13
	-- upvalues: Constants (copy), RbxDesignFoundations (copy)
	return {
		[Constants.ThemeName.Light:lower()] = RbxDesignFoundations.tokens[p1].Light,
		[Constants.ThemeName.Dark:lower()] = RbxDesignFoundations.tokens[p1].Dark
	}
end

return {
	TokenPackageIndexMap = {
		[Constants.DeviceType.Console] = getThemePackageIndex("Console"),
		[Constants.DeviceType.Desktop] = getThemePackageIndex("Desktop"),
		[Constants.DeviceType.Tablet] = getThemePackageIndex("Desktop"),
		[Constants.DeviceType.Phone] = getThemePackageIndex("Desktop"),
		[Constants.DeviceType.VR] = getThemePackageIndex("Desktop"),
		[Constants.DeviceType.Unknown] = getThemePackageIndex("Desktop")
	},
	GetTokenGenerators = function(p2) -- line: 30
		-- upvalues: Constants (copy), RbxDesignFoundations (copy)
		local v9 = p2:lower()

		if v9 == Constants.ThemeName.Dark:lower() then
			return RbxDesignFoundations.tokens.Common.Builder.Dark
		end

		if v9 == Constants.ThemeName.Light:lower() then
			return RbxDesignFoundations.tokens.Common.Builder.Light
		end

		return nil
	end,
	GetFoundationTokens = function(p3) -- line: 40
		-- upvalues: ParentParent2 (copy), Constants (copy)
		local Tokens = require(ParentParent2.RbxDesignFoundationsV2).Tokens
		local v12 = p3:lower()

		if v12 == Constants.ThemeName.Dark:lower() then
			return Tokens.Dark
		end

		if v12 == Constants.ThemeName.Light:lower() then
			return Tokens.Light
		end

		return nil
	end,
	SchemaPackage = {
		Validators = {
			Global = require(RbxDesignFoundations.tokens.Schema.Validators.validateGlobal)(t),
			Semantic = require(RbxDesignFoundations.tokens.Schema.Validators.validateSemantic)(t),
			Component = require(RbxDesignFoundations.tokens.Schema.Validators.validateComponent)(t)
		},
		Types = {
			GlobalType = require(RbxDesignFoundations.tokens.Schema.Types.GlobalType),
			SemanticType = require(RbxDesignFoundations.tokens.Schema.Types.SemanticType),
			ComponentType = require(RbxDesignFoundations.tokens.Schema.Types.ComponentType)
		}
	}
}
