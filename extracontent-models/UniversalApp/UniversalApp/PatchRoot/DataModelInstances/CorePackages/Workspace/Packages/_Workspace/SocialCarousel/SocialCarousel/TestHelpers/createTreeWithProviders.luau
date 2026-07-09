local Parent = script:FindFirstAncestor("SocialCarousel").Parent
local React = require(Parent.React)
local Rodux = require(Parent.Rodux)
local UniversalAppPolicy = require(Parent.UniversalAppPolicy).UniversalAppPolicy
local SocialTestHelpers = require(Parent.Dev.SocialTestHelpers)
local Cryo = require(Parent.Cryo)
local createTreeWithProviders = SocialTestHelpers.TestHelpers.createTreeWithProviders

local function v8(p1) -- line: 11
	-- upvalues: React (copy), UniversalAppPolicy (copy)
	return React.createElement(UniversalAppPolicy.Provider, {
		policy = { function() -- line: 14
			return {
				useGridPageLayout = function() -- line: 16
					return true
				end,
				getCanUsePlatformChat = function() -- line: 19
					return false
				end
			}
		end }
	}, p1)
end

local v9 = Rodux.Store.new(function(_, _) -- line: 28
	return {
		ScreenSize = Vector2.new(600, 300),
		TopBar = {
			topBarHeight = 0
		},
		GlobalGuiInset = {
			left = 0,
			top = 0,
			right = 0,
			bottom = 0
		}
	}
end)

return function(p4, p5) -- line: 43
	-- upvalues: createTreeWithProviders (copy), Cryo (copy), v8 (copy), v9 (copy)
	return createTreeWithProviders(p4, Cryo.Dictionary.join(p5, {
		includeFoundationProvider = true,
		mockProvider = v8,
		store = v9
	}))
end
