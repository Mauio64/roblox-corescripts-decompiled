local CorePackages = game:GetService("CorePackages")

local parent = script.Parent.Parent
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local Style = require(CorePackages.Workspace.Packages.Style)
local AppFonts = Style.AppFonts
local UtilityFunctions = require(parent.UtilityFunctions)
local GetAssetFavoriteCount = require(parent.Thunks.GetAssetFavoriteCount)
local GetBundleFavoriteCount = require(parent.Thunks.GetBundleFavoriteCount)
local GotCurrentFavoriteCount = require(parent.Selectors.GotCurrentFavoriteCount)
local getSelectionImageObjectRegular = require(parent.getSelectionImageObjectRegular)

local extended = Roact.PureComponent:extend("Favorites")

function extended:setText()
	local assetInfo = self.props.assetInfo or {}
	local v = assetInfo.parentBundleId ~= nil

	local bundleInfo = self.props.bundleInfo

	if v then
		local bundleId = UtilityFunctions.getBundleId(assetInfo)

		if bundleInfo[bundleId] then
			self.numFavorites = bundleInfo[bundleId].numFavorites
		end
	elseif assetInfo then
		self.numFavorites = assetInfo.numFavorites
	end
end

function extended:init()
	self.numFavorites = ""
	self.selectionImageObject = getSelectionImageObjectRegular()
end

function extended.willUpdate(p, p2)
	local getAssetFavoriteCount = p.props.getAssetFavoriteCount
	local getBundleFavoriteCount = p.props.getBundleFavoriteCount

	if p2.assetInfo then
		local assetInfo = p2.assetInfo
		local v = assetInfo.parentBundleId ~= nil

		if not p2.gotCurrentFavoriteCount then
			coroutine.wrap(function()
				if not v then
					getAssetFavoriteCount(assetInfo.assetId)
					return
				end

				getBundleFavoriteCount((UtilityFunctions.getBundleId(assetInfo)))
			end)()
		end
	end
end

function extended:render()
	self:setText()

	return Roact.createElement(
		"Frame",
		{ Size = UDim2.new(1, 0, 0, 16), BackgroundTransparency = 1, LayoutOrder = 3 },
		{
			FavoriteIcon = Roact.createElement("ImageButton", {
				Selectable = false,
				Size = UDim2.new(0, 16, 0, 16),
				BackgroundTransparency = 1,
				Image = "rbxasset://textures/ui/InspectMenu/ico_favorite.png",
				SelectionImageObject = self.selectionImageObject
			}),
			FavoriteText = Roact.createElement("TextLabel", {
				Size = UDim2.new(1, -16, 1, 0),
				Position = UDim2.new(0, 21, 0, 0),
				BackgroundTransparency = 1,
				Text = self.numFavorites or "",
				Font = AppFonts.default:getDefault(),
				TextXAlignment = Enum.TextXAlignment.Left,
				TextSize = 12,
				TextColor3 = Color3.new(1, 1, 1)
			})
		}
	)
end

function extended.shouldUpdate(_, p): boolean
	return if p.detailsInformation.viewingDetails then true else false
end

return RoactRodux.UNSTABLE_connect2(function(data, _)
	local assetId = data.detailsInformation.assetId

	return {
		detailsInformation = data.detailsInformation,
		assetInfo = data.assets[assetId],
		bundleInfo = data.bundles,
		gotCurrentFavoriteCount = GotCurrentFavoriteCount(data)
	}
end, function(callback)
	return {
		getAssetFavoriteCount = function(p)
			callback(GetAssetFavoriteCount(p))
		end,
		getBundleFavoriteCount = function(p)
			callback(GetBundleFavoriteCount(p))
		end
	}
end)(extended)
