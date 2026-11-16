local InExperienceSideSheet = script:FindFirstAncestor("InExperienceSideSheet")
local parent = InExperienceSideSheet.Parent

local Foundation = require(parent.Foundation)
local React = require(parent.React)
local SignalsReact = require(parent.SignalsReact)

local GetSideSheetConfigStore = require(InExperienceSideSheet.Stores.GetSideSheetConfigStore)

local useTokens = Foundation.Hooks.useTokens

local function getBackgroundTransparency(p)
	return GetSideSheetConfigStore(p).getBackgroundTransparency(p)
end

local function useBackgroundStyle()
	local v = useTokens()
	local v2 = SignalsReact.useSignalBinding(getBackgroundTransparency)

	return (React.useMemo(function()
		return v2:map(function(transparency)
			return { Color3 = v.Color.OverMedia.OverMedia_0.Color3, Transparency = transparency }
		end)
	end, { v.Color.OverMedia.OverMedia_0.Color3 }))
end

return useBackgroundStyle
