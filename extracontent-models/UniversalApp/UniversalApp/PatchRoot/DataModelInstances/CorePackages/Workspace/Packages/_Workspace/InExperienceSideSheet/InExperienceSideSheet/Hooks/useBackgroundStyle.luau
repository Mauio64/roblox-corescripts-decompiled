local InExperienceSideSheet = script:FindFirstAncestor("InExperienceSideSheet")
local InExperienceSideSheetParent = InExperienceSideSheet.Parent
local Foundation = require(InExperienceSideSheetParent.Foundation)
local React = require(InExperienceSideSheetParent.React)
local SignalsReact = require(InExperienceSideSheetParent.SignalsReact)
local GetSideSheetConfigStore = require(InExperienceSideSheet.Stores.GetSideSheetConfigStore)
local useTokens = Foundation.Hooks.useTokens

local function getBackgroundTransparency(p1) -- line: 12
	-- upvalues: GetSideSheetConfigStore (copy)
	return GetSideSheetConfigStore(p1).getBackgroundTransparency(p1)
end
local function useBackgroundStyle() -- line: 16
	-- upvalues: useTokens (copy), SignalsReact (copy), getBackgroundTransparency (copy), React (copy)
	local v11 = useTokens()
	local v12 = SignalsReact.useSignalBinding(getBackgroundTransparency)

	return (React.useMemo(function() -- line: 20
		-- upvalues: v12 (copy), v11 (copy)
		return v12:map(function(p2) -- line: 21
			-- upvalues: v11 (copy)
			return {
				Color3 = v11.Color.OverMedia.OverMedia_0.Color3,
				Transparency = p2
			}
		end)
	end, { v11.Color.OverMedia.OverMedia_0.Color3 }))
end

return useBackgroundStyle
