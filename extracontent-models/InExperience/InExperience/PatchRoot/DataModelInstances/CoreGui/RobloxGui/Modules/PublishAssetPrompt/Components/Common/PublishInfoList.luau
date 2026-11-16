local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local ItemDetails = require(CorePackages.Workspace.Packages.ItemDetails)
local ItemInfoList = ItemDetails.ItemInfoList
local Localization = require(CorePackages.Workspace.Packages.Localization)
local useLocalization = Localization.Hooks.useLocalization

local HttpRbxApiService = game:GetService("HttpRbxApiService")
local CoreGui = game:GetService("CoreGui")
local RobloxGui = CoreGui:WaitForChild("RobloxGui")
local httpRequest = require(RobloxGui.Modules.Common.httpRequest)
local v = httpRequest(HttpRbxApiService)

local GameDetailRodux = require(CorePackages.Workspace.Packages.GameDetailRodux)
local GetGameNameAndDescription = GameDetailRodux.GetGameNameAndDescription

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local function PublishInfoList(p)
	local ref = React.useRef(false)

	assert(LocalPlayer, "LocalPlayer must not be nil")
	local name = LocalPlayer.Name
	local state, setState = React.useState(nil)
	local typeName = p.typeName
	local layoutOrder = p.LayoutOrder

	local v2 = useLocalization({
		creatorText = "Feature.Catalog.Label.Filter.Creator",
		attributionText = "Feature.Catalog.Label.Attribution",
		typeText = "Feature.Catalog.Label.CategoryType"
	})

	React.useEffect(function()
		ref.current = true
		GetGameNameAndDescription(v, game.GameId):andThen(function(p2)
			if ref.current and p2.Name then
				setState(p2.Name)
			end
		end)
		return function()
			ref.current = false
		end
	end, {})

	return React.createElement(ItemInfoList, {
		rowData = {
			{
				infoName = v2.creatorText,
				infoData = name,
				hasVerifiedBadge = LocalPlayer.HasVerifiedBadge,
				isLoading = name == nil,
				Selectable = false
			},
			{
				infoName = v2.attributionText,
				infoData = state,
				isLoading = state == nil,
				Selectable = false
			},
			{
				infoName = v2.typeText,
				infoData = typeName,
				isLoading = typeName == nil,
				Selectable = false
			}
		},
		LayoutOrder = layoutOrder
	})
end

return PublishInfoList
