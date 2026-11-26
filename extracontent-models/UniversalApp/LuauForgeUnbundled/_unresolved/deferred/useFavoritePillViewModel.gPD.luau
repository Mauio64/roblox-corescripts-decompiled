local CorePackages = game:GetService("CorePackages")

local HttpService = game:GetService("HttpService")

local React = require(CorePackages.Packages.React)
local roactRodux = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux
local useSelector = roactRodux.useSelector
local useDispatch = roactRodux.useDispatch
local useStore = roactRodux.useStore

local module = require("@luauforge/bundled/eie")
local module2 = require("@luauforge/bundled/gxM")
local module3 = require("@luauforge/bundled/egx")
local module4 = require("@luauforge/bundled/egY")
local module5 = require("@luauforge/bundled/fDf")

local AvatarExperienceAnalytics = require("@game/CorePackages/Workspace/Packages/AvatarExperienceAnalytics")
local sendUnifiedEventLog = AvatarExperienceAnalytics.sendUnifiedEventLog
local unifiedEventLogEnums = AvatarExperienceAnalytics.UnifiedEventLogEnums
local unifiedLoggingElementNameEnums = AvatarExperienceAnalytics.Enums.UnifiedLoggingElementNameEnums
local getMarketplaceUnifiedItemType = AvatarExperienceAnalytics.Utils.getMarketplaceUnifiedItemType

local unifiedLoggingSurface = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation").Enums.UnifiedLoggingSurface
local AvatarExperienceFlags = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags")
local fFlagAXLogFavoritePillToggle = AvatarExperienceFlags.FFlagAXLogFavoritePillToggle
local fFlagAXFavoritePillRequireItemId = AvatarExperienceFlags.FFlagAXFavoritePillRequireItemId

local numberLocalization = require("@game/CorePackages/Workspace/Packages/Localization").NumberLocalization

local fFlagAXShowFavoritePillFtuxTooltip = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags").FFlagAXShowFavoritePillFtuxTooltip

local module8 = require("@luauforge/deferred/gPE")

local module9 = require("@luauforge/deferred/gPF")

local module10 = require("@luauforge/deferred/gPG")

local module11 = require("@luauforge/deferred/gPH")

local defineFastString = game:DefineFastString("AXFavoritePillFtuxTooltip", "AXFavoritePillFtuxTooltip")

local itemType = require("@luauforge/bundled/dPN").ItemType

require("@luauforge/bundled/dKT")

local module12 = require("@luauforge/deferred/gLf")
local module13 = require("@luauforge/deferred/gLg")
local module14 = require("@luauforge/deferred/gLh")
local module15 = require("@luauforge/deferred/gLi")
local module16 = require("@luauforge/deferred/gPI")

local module17 = require("@luauforge/bundled/egt")
local module18 = require("@luauforge/bundled/dFm")
local module19 = require("@luauforge/bundled/dzE")

require("@luauforge/deferred/gPC")

local function selectIsFavorited(p2, p3, p4)
	if p3 == itemType.Asset then
		return p2.AvatarExperience.Catalog.AssetFavorites[p4]
	end

	if p3 == itemType.Bundle then
		return p2.AvatarExperience.Catalog.BundleFavorites[p4]
	end

	if p3 ~= itemType.Look then
		return nil
	end

	local look = p2.AvatarExperience.AvatarScene.Looks[p4]

	if look == nil then
		return nil
	end

	return look.isFavorited
end

local function useFavoritePillViewModel(data)
	local v5 = data.kind
	local v6 = data.itemId

	if fFlagAXFavoritePillRequireItemId then
		v5 = v5 or ""
		v6 = v6 or ""
	end

	local lookType = data.lookType
	local favoritesCount = data.favoritesCount

	local v7 = useDispatch()
	local v8 = useStore()
	local v9 = module(module3)

	local v10 = module(module4)
	local v11 = module(module5)

	local v12 = module2({ favoritesLabel = "Feature.Catalog.Label.Favorites" })

	local v13 = useSelector(function(p2)
		local v14 = v5
		local v15 = v6

		if v14 == itemType.Asset then
			return p2.AvatarExperience.Catalog.AssetFavorites[v15]
		end

		if v14 == itemType.Bundle then
			return p2.AvatarExperience.Catalog.BundleFavorites[v15]
		end

		if v14 ~= itemType.Look then
			return nil
		end

		local look = p2.AvatarExperience.AvatarScene.Looks[v15]

		if look == nil then
			return nil
		end

		return look.isFavorited
	end)

	local state, setState = React.useState(0)

	local state2, setState2 = React.useState(false)

	local state3, setState3 = React.useState(false)

	local ref = React.useRef(nil)
	local ref2 = React.useRef(false)
	local ref3 = React.useRef(false)

	local ref4 = React.useRef(nil)
	local v14

	if fFlagAXLogFavoritePillToggle then
		v14 = React.useCallback(function(p2)
			sendUnifiedEventLog({
				action = unifiedEventLogEnums.MarketplaceUnifiedAction.UI_ELEMENT_CLICK,
				elementName = unifiedLoggingElementNameEnums.ITEM_DETAILS_FAVORITE_BUTTON,
				surface = unifiedLoggingSurface.ITEM_DETAILS,
				itemId = v6,
				itemType = getMarketplaceUnifiedItemType(v5),
				elementMetadata = HttpService:JSONEncode({
					change_from_favorited_status = tostring(not p2),
					change_to_favorited_status = tostring(p2)
				})
			})
		end, { v5, v6 })
	else
		v14 = nil
	end

	local v15 = module9()

	local v16 = module8({
		identity = v5 .. ":" .. v6,
		enabled = v15,
		getServerValue = function()
			local state4 = v8:getState()
			local v17 = v5
			local v18 = v6

			if v17 == itemType.Asset then
				return state4.AvatarExperience.Catalog.AssetFavorites[v18]
			end

			if v17 == itemType.Bundle then
				return state4.AvatarExperience.Catalog.BundleFavorites[v18]
			end

			if v17 ~= itemType.Look then
				return nil
			end

			local look = state4.AvatarExperience.AvatarScene.Looks[v18]

			if look == nil then
				return nil
			end

			return look.isFavorited
		end,
		write = function(p2)
			if v5 == itemType.Asset then
				return v7(module13(v6, p2))
			end

			if v5 == itemType.Bundle then
				return v7(module15(v6, p2))
			end

			if v5 == itemType.Look then
				return v7(module16(v9, v6, p2, lookType))
			end

			return nil
		end,
		debounceMs = module10(),
		maxRetries = module11(),
		retryBaseMs = 1000,
		retryCapMs = 8000,
		onWriteStart = function(p2)
			local v17 = if v5 == itemType.Look then lookType or v5 else v5
			v11.clickFavoriteItemButton(v6, v17, p2)

			if fFlagAXLogFavoritePillToggle and v14 ~= nil then
				v14(p2)
			end
		end,
		onCommitted = function(p2)
			v7(module18({
				toastMessage = p2 and "Feature.Catalog.Toast.AddedToFavorites" or "Feature.Catalog.Toast.RemovedFromFavorites",
				toastType = module19.SuccessConfirmation
			}))
		end,
		onGiveUp = function()
			if v5 == itemType.Look then
				v7(module17({ HttpError = Enum.HttpError.OK }))
			end
		end
	})

	local v17 = ref.current ~= nil

	if v15 then
		state3 = if v16.displayValue == nil then v13 else v16.displayValue
	elseif not (v17 or state2) then
		state3 = v13
	end

	React.useEffect(function()
		if v13 ~= nil then
			return
		end

		if v5 == itemType.Asset then
			v7(module12(v6))
		elseif v5 == itemType.Bundle then
			v7(module14(v6))
		end
	end, { v7, v13, v6, v5 })

	local state4, setState4 = React.useState(nil)
	React.useEffect(function()
		if v13 == nil or favoritesCount == nil then
			return
		end

		setState4(function(p2)
			if p2 == nil or p2.count ~= favoritesCount then
				return { favorited = v13, count = favoritesCount }
			end

			return p2
		end)
	end, { v13, favoritesCount })
	local v18

	if state4 == nil or state3 == nil then
		v18 = favoritesCount
	else
		local v19 = state3 == state4.favorited and 0 or state3 and 1 or -1

		v18 = math.max(0, state4.count + v19)
	end

	local function fn(current)
		if ref2.current then
			return
		end

		ref2.current = true
		setState2(true)
		ref3.current = current
		setState3(current)

		local v19 = if v5 == itemType.Look then lookType or v5 else v5
		v11.clickFavoriteItemButton(v6, v19, current)

		if fFlagAXLogFavoritePillToggle and v14 ~= nil then
			v14(current)
		end

		local v20 = nil

		if v5 == itemType.Asset then
			v20 = v7(module13(v6, current))
		elseif v5 == itemType.Bundle then
			v20 = v7(module15(v6, current))
		elseif v5 == itemType.Look then
			v20 = v7(module16(v9, v6, current, lookType))
		end

		local function clearWriting()
			ref2.current = false
			setState2(false)
		end

		local function clearDesired()
			ref.current = nil
			setState(function(p2)
				return p2 + 1
			end)
		end

		local function followUpIfNeeded(p2): boolean
			local current2 = ref.current

			if current2 == nil or current2 == p2 then
				return false
			end

			local current3 = ref4.current

			if current3 ~= nil then
				current3(current2)
			end

			return true
		end

		if v20 ~= nil then
			v20:andThen(function()
				ref2.current = false
				setState2(false)

				local current2 = ref.current
				local flag

				if current2 == nil or current2 == current then
					flag = false
				else
					local current3 = ref4.current

					if current3 ~= nil then
						current3(current2)
					end

					flag = true
				end

				if flag then
					return
				end

				ref.current = nil
				setState(function(p2)
					return p2 + 1
				end)

				v7(module18({
					toastMessage = current and "Feature.Catalog.Toast.AddedToFavorites" or "Feature.Catalog.Toast.RemovedFromFavorites",
					toastType = module19.SuccessConfirmation
				}))
			end, function()
				ref2.current = false
				setState2(false)

				local current2 = ref.current
				local flag

				if current2 == nil or current2 == current then
					flag = false
				else
					local current3 = ref4.current

					if current3 ~= nil then
						current3(current2)
					end

					flag = true
				end

				if flag then
					return
				end

				ref.current = nil
				setState(function(p2)
					return p2 + 1
				end)

				if v5 == itemType.Look then
					v7(module17({ HttpError = Enum.HttpError.OK }))
				end
			end)
			return
		end

		ref2.current = false
		setState2(false)

		ref.current = nil
		setState(function(p2)
			return p2 + 1
		end)
	end

	local v23 = React.useCallback(fn, {
		v5,
		v6,
		lookType,
		v7,
		v9,
		v11,
		if fFlagAXLogFavoritePillToggle then v14 else nil
	})

	ref4.current = v23

	local updateValue = v16.updateValue
	local v24 = React.useCallback(function()
		local state5 = v8:getState()
		local v25 = v5
		local v26 = v6
		local v27

		if v25 == itemType.Asset then
			v27 = state5.AvatarExperience.Catalog.AssetFavorites[v26]
		elseif v25 == itemType.Bundle then
			v27 = state5.AvatarExperience.Catalog.BundleFavorites[v26]
		elseif v25 == itemType.Look then
			local look = state5.AvatarExperience.AvatarScene.Looks[v26]

			if look ~= nil then
				v27 = look.isFavorited
			end
		end

		if v27 == nil then
			return
		end

		if v15 then
			local v28 = v27
			updateValue(function(p2): boolean
				if fFlagAXLogFavoritePillToggle then
				end

				if p2 == nil then
					p2 = v28
				end

				return not p2
			end)

			return
		end

		if ref.current == nil then
			if ref2.current then
				v27 = ref3.current
			end
		else
			v27 = ref.current
		end

		local v28 = not v27
		ref.current = v28
		setState(function(p2)
			return p2 + 1
		end)

		ref3.current = v28
		setState3(v28)

		if not ref2.current then
			v23(v28)
		end
	end, { v8, v5, v6, v23, v15, updateValue })

	local v25 = React.useCallback(function(p2)
		return numberLocalization.abbreviate(p2, v10:GetLocale())
	end, { v10 })

	local ref5 = if fFlagAXShowFavoritePillFtuxTooltip then React.useRef(nil) else nil
	local v26

	if fFlagAXShowFavoritePillFtuxTooltip then
		v26 = React.useCallback(function()
			v24()

			if ref5 and ref5.current then
				ref5.current()
			end
		end, { v24 })
	end

	local v27 = fFlagAXShowFavoritePillFtuxTooltip and {
		popoverSide = "Bottom",
		tooltipStorageKey = defineFastString,
		tooltipLocalizationKey = "Feature.Catalog.Message.FTUXFavoritePillTooltip",
		showTooltip = true,
		dismissTooltipRef = ref5
	} or nil

	local v28 = {
		favoritesCount = v18,
		isFavorited = state3,
		isDisabled = state3 == nil,
		onActivated = nil,
		favoritesLabel = 0,
		formatCount = 0,
		tooltipProps = 0,
		LayoutOrder = 0
	}

	if not fFlagAXShowFavoritePillFtuxTooltip then
		v26 = v24
	end

	v28.onActivated = v26
	v28.favoritesLabel = v12.favoritesLabel
	v28.formatCount = v25

	if not fFlagAXShowFavoritePillFtuxTooltip then
		v27 = nil
	end

	v28.tooltipProps = v27
	v28.LayoutOrder = data.LayoutOrder
	return v28
end

return useFavoritePillViewModel
