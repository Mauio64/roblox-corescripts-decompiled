local parent = script:FindFirstAncestor("ProfilePlatform").Parent

local React = require(parent.React)
local Rodux = require(parent.Rodux)

local captured = {
	sheetRootProps = nil,
	dialogRootProps = nil,
	dialogTitleProps = nil,
	dialogActionsProps = nil
}

local function renderChildren(props)
	return React.createElement("Frame", nil, props.children or props[React.Children])
end

local v = {
	["Feature.Catalog.Label.BuyItems"] = "Buy Items",
	["Feature.Profile.Header.BuyWholeLook"] = "Buy whole look",
	["IAPExperience.PurchasePrompt.Header.BuyAvatar"] = "Buy avatar",
	["IAPExperience.PurchasePrompt.Action.Buy"] = "Buy",
	["IAPExperience.PurchasePrompt.Label.TotalPriceV2"] = "Total price",
	["IAPExperience.InsufficientRobux.Title.InsufficientRobux"] = "Not enough Robux",
	["IAPExperience.InsufficientRobux.Text.CurrentBalance"] = "Current balance",
	["IAPExperience.InsufficientRobux.Text.MissingRobux"] = "You need",
	["IAPExperience.InsufficientRobux.Action.BuyRobux"] = "Buy Robux"
}

local priceStatus = {
	Owned = "Owned",
	Free = "Free",
	PurchaseFromRoblox = "PurchaseFromRoblox",
	PurchaseFromResale = "PurchaseFromResale",
	OffSale = "OffSale",
	SoldOut = "SoldOut",
	Unavailable = "Unavailable",
	InExperienceOnly = "InExperienceOnly",
	QuantityLimitReached = "QuantityLimitReached"
}

local function getPriceStatusInShop(data)
	if not data then
		return priceStatus.Unavailable
	end

	if data.isOwned then
		return priceStatus.Owned
	end

	if data.isOffSale then
		return priceStatus.OffSale
	end

	if data.collectibleItemDetails then
		return priceStatus.PurchaseFromResale
	end

	if data.priceInRobux == 0 then
		return priceStatus.Free
	end

	if data.priceInRobux then
		return priceStatus.PurchaseFromRoblox
	end

	return priceStatus.Unavailable
end

local CreateRecentActivityTestMocks = {}
CreateRecentActivityTestMocks.captured = captured

function CreateRecentActivityTestMocks.resetCaptured()
	captured.sheetRootProps = nil
	captured.dialogRootProps = nil
	captured.dialogTitleProps = nil
	captured.dialogActionsProps = nil
end

function CreateRecentActivityTestMocks.createFoundationMock(p)
	local function SheetRoot(sheetRootProps)
		captured.sheetRootProps = sheetRootProps
		return renderChildren(sheetRootProps)
	end

	local function DialogRoot(dialogRootProps)
		captured.dialogRootProps = dialogRootProps
		return renderChildren(dialogRootProps)
	end

	local function DialogTitle(dialogTitleProps)
		captured.dialogTitleProps = dialogTitleProps
		return React.createElement("Frame")
	end

	local function DialogActions(dialogActionsProps)
		captured.dialogActionsProps = dialogActionsProps
		return React.createElement("Frame")
	end

	return (setmetatable({
		Sheet = {
			Root = SheetRoot,
			Header = renderChildren,
			Content = renderChildren,
			Actions = renderChildren
		},
		Dialog = {
			Root = DialogRoot,
			Title = DialogTitle,
			Content = renderChildren,
			Actions = DialogActions
		}
	}, { __index = p }))
end

function CreateRecentActivityTestMocks.createLocalizationMock()
	return {
		Hooks = {
			useLocalization = function(items)
				local result = {}

				for k, item in items do
					if type(item) == "table" then
						item = item[1]
					end

					result[k] = v[item] or item
				end

				return result
			end
		},
		NumberLocalization = {
			localize = function(p: number, _: string?)
				return (tostring(p))
			end
		}
	}
end

function CreateRecentActivityTestMocks.createInspectAndBuyMock(options)
	return {
		Components = options or {},
		Utils = {
			getPriceStatusInShop = getPriceStatusInShop,
			getPriceLineContent = function(_, _, _)
				return {}
			end
		},
		Enums = { PriceStatus = priceStatus },
		Constants = {
			AssetLocalizationKeys = {},
			BundleLocalizationKeys = {},
			PriceStatusLocalizationKeys = {}
		}
	}
end

function CreateRecentActivityTestMocks.createMockStore()
	return Rodux.Store.new(function()
		return {
			ScreenSize = Vector2.new(800, 600),
			TopBar = { statusBarHeight = 0 }
		}
	end, {}, { Rodux.thunkMiddleware })
end

function CreateRecentActivityTestMocks.makeDisplayItem(items)
	local displayItem = {
		id = "1",
		name = "Test Item",
		priceInRobux = 100,
		itemSubType = "8",
		creator = { creatorName = "Creator", creatorHasVerifiedBadge = false },
		isOwned = false,
		isOffSale = false,
		saleLocationType = "ShopAndAllExperiences",
		collectibleProductId = "product-1",
		itemType = "Asset",
		bundlePartsCount = 0,
		bundleAssetIds = {}
	}

	if items then
		for k, item in items do
			displayItem[k] = item
		end
	end

	return displayItem
end

CreateRecentActivityTestMocks.PriceStatus = priceStatus
return CreateRecentActivityTestMocks
