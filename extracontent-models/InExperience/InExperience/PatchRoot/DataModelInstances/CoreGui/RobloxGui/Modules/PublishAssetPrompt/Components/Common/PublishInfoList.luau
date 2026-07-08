local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local ItemInfoList = require(CorePackages.Workspace.Packages.ItemDetails).ItemInfoList
local useLocalization = require(CorePackages.Workspace.Packages.Localization).Hooks.useLocalization
local HttpRbxApiService = game:GetService("HttpRbxApiService")
local RobloxGui = game:GetService("CoreGui"):WaitForChild("RobloxGui")
local v7 = require(RobloxGui.Modules.Common.httpRequest)(HttpRbxApiService)
local GetGameNameAndDescription = require(CorePackages.Workspace.Packages.GameDetailRodux).GetGameNameAndDescription
local LocalPlayer = game:GetService("Players").LocalPlayer

local function PublishInfoList(t1: {[any]: any}) -- line: 27
	-- upvalues: React (copy), LocalPlayer (copy), useLocalization (copy), GetGameNameAndDescription (copy), v7 (copy), ItemInfoList (copy)
	local v12 = React.useRef(false)

	assert(LocalPlayer, "LocalPlayer must not be nil")

	local LocalPlayerName = LocalPlayer.Name
	local v14, v15 = React.useState(nil)
	local typeName = t1.typeName
	local t1LayoutOrder = t1.LayoutOrder
	local v18 = useLocalization({
		creatorText = "Feature.Catalog.Label.Filter.Creator",
		attributionText = "Feature.Catalog.Label.Attribution",
		typeText = "Feature.Catalog.Label.CategoryType"
	})

	React.useEffect(function() -- line: 43
		-- upvalues: v12 (copy), GetGameNameAndDescription (copy), v7 (copy), v15 (copy)
		v12.current = true
		GetGameNameAndDescription(v7, game.GameId):andThen(function(p1) -- line: 45
			-- upvalues: v12 (copy), v15 (copy)
			if v12.current and p1.Name then
				v15(p1.Name)
			end
		end)

		return function() -- line: 50
			-- upvalues: v12 (copy)
			v12.current = false
		end
	end, {})

	return React.createElement(ItemInfoList, {
		rowData = {
			{
				Selectable = false,
				infoName = v18.creatorText,
				infoData = LocalPlayerName,
				hasVerifiedBadge = LocalPlayer.HasVerifiedBadge,
				isLoading = LocalPlayerName == nil
			},
			{
				Selectable = false,
				infoName = v18.attributionText,
				infoData = v14,
				isLoading = v14 == nil
			},
			{
				Selectable = false,
				infoName = v18.typeText,
				infoData = typeName,
				isLoading = typeName == nil
			}
		},
		LayoutOrder = t1LayoutOrder
	})
end

return PublishInfoList
