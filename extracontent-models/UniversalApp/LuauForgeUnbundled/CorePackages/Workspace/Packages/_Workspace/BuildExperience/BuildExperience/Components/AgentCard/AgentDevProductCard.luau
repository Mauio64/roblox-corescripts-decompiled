local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Foundation")
local Localization = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Localization")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/React")
require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Chat/chatTypes")
local LocalizationStrings = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/LocalizationStrings")
local FFlagBuildExperienceMonetizationNativeUI = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagBuildExperienceMonetizationNativeUI")
local FFlagBuildExperienceDevProductRecovery = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagBuildExperienceDevProductRecovery")

local FFlagCreatorAgentChatMonetizationToolHelpers = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagCreatorAgentChatMonetizationToolHelpers")

local v5 = if FFlagBuildExperienceMonetizationNativeUI then require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/FoundationCloudAssets") else nil

local LocalizationService = game:GetService("LocalizationService")
local localizationRoactContext = Localization.LocalizationRoactContext
local numberLocalization = Localization.NumberLocalization
local useLocalization = Localization.Hooks.useLocalization

local AgentCard = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/AgentCard/AgentCard")
local AgentCardActions = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/AgentCard/AgentCardActions")
local ChatCardPriority = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/Chat/ChatCardEmphasis/ChatCardPriority")
local useChatCardEmphasis = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/Chat/ChatCardEmphasis/useChatCardEmphasis")
local FFlagBuildExperienceChatCardEmphasis = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagBuildExperienceChatCardEmphasis")

local FFlagBuildExperienceMonetizationFailureCauses = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagBuildExperienceMonetizationFailureCauses")

local FFlagBuildExperienceMonetizationCardFixes = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagBuildExperienceMonetizationCardFixes")
local button = Foundation.Button
local image = Foundation.Image
local sheet = Foundation.Sheet
local text = Foundation.Text
local view = Foundation.View

local buttonVariant = Foundation.Enums.ButtonVariant
local fillBehavior = Foundation.Enums.FillBehavior
local inputSize = Foundation.Enums.InputSize
local assetId

if FFlagBuildExperienceMonetizationNativeUI then
	v5.preloadAsset("pictograms/robux")
	assetId = v5.Assets["pictograms/robux"].assetId
else
	assetId = nil
end

local v6 = {
	title = LocalizationStrings.AGENT_DEV_PRODUCT_TITLE,
	create = LocalizationStrings.AGENT_DEV_PRODUCT_CREATE,
	update = LocalizationStrings.AGENT_DEV_PRODUCT_UPDATE,
	activate = LocalizationStrings.AGENT_DEV_PRODUCT_ACTIVATE,
	deactivate = LocalizationStrings.AGENT_DEV_PRODUCT_DEACTIVATE
}

local v7 = {
	gamePass = {
		title = LocalizationStrings.AGENT_GAME_PASS_TITLE,
		create = LocalizationStrings.AGENT_GAME_PASS_CREATE,
		update = LocalizationStrings.AGENT_GAME_PASS_UPDATE,
		activate = LocalizationStrings.AGENT_GAME_PASS_ACTIVATE,
		deactivate = LocalizationStrings.AGENT_GAME_PASS_DEACTIVATE
	},
	subscription = {
		title = LocalizationStrings.AGENT_SUBSCRIPTION_TITLE,
		create = LocalizationStrings.AGENT_SUBSCRIPTION_CREATE,
		update = LocalizationStrings.AGENT_SUBSCRIPTION_UPDATE,
		activate = LocalizationStrings.AGENT_SUBSCRIPTION_ACTIVATE,
		deactivate = LocalizationStrings.AGENT_SUBSCRIPTION_DEACTIVATE,
		deactivateCancelRenewals = LocalizationStrings.AGENT_SUBSCRIPTION_DEACTIVATE_CANCEL_RENEWALS,
		delete = LocalizationStrings.AGENT_SUBSCRIPTION_DELETE
	}
}

local v8 = {
	consumable = LocalizationStrings.AGENT_SUBSCRIPTION_PRODUCT_TYPE_CONSUMABLE,
	currency = LocalizationStrings.AGENT_SUBSCRIPTION_PRODUCT_TYPE_CURRENCY,
	durable = LocalizationStrings.AGENT_SUBSCRIPTION_PRODUCT_TYPE_DURABLE
}

local function summaryKeys(p2)
	local v9

	if p2.itemKind == nil then
		v9 = v6
		return v9
	end

	v9 = v7[p2.itemKind]

	if v9 then
		return v9
	end

	return v6
end

local function idActionKey(p2, p3)
	if p3.action == "create" or p3.action == "update" or p3.action == "title" then
		return nil
	end

	if p3.action == "deactivate" and p3.cancelRenewals == true and p2.deactivateCancelRenewals ~= nil then
		return p2.deactivateCancelRenewals
	end

	return p2[p3.action]
end

local function itemIdText(p2)
	return p2.itemId or tostring(p2.productId)
end

local function formatSummary(object, p2, p3)
	return object:Format(p2, p3)
end

local function formatPrice(p2)
	return numberLocalization.localize(tostring(p2), LocalizationService.RobloxLocaleId)
end

local function kindText(data, object)
	local AGENT_SUBSCRIPTION_PRODUCT_TYPE = LocalizationStrings.AGENT_SUBSCRIPTION_PRODUCT_TYPE
	local v11 = if data.itemKind == nil then v6 else v7[data.itemKind] or v6

	return formatSummary(object, AGENT_SUBSCRIPTION_PRODUCT_TYPE, {
		PRODUCT_TYPE = object:Format(v11.title, {})
	})
end

local function createCardTitle(p2, p3, p4, price)
	local AGENT_MONETIZATION_CREATE_TITLE = LocalizationStrings.AGENT_MONETIZATION_CREATE_TITLE
	local v10 = {
		NAME = p2.name or p4,
		PRICE = 0
	}

	if p2.priceInRobux ~= nil then
		local priceInRobux = p2.priceInRobux
		price = numberLocalization.localize(tostring(priceInRobux), LocalizationService.RobloxLocaleId)
	end

	v10.PRICE = price
	return formatSummary(p3, AGENT_MONETIZATION_CREATE_TITLE, v10)
end

local function appendSubscriptionProductType(list, data, object)
	if data.itemKind ~= "subscription" or data.productType == nil then
		return
	end

	local v9 = v8[data.productType]

	if v9 == nil then
		return
	end

	table.insert(
		list,
		formatSummary(object, LocalizationStrings.AGENT_SUBSCRIPTION_PRODUCT_TYPE, {
			PRODUCT_TYPE = object:Format(v9, {})
		})
	)
end

local function devProductSummaryText(data, object, p2, p3)
	local action = data.action

	if action == "create" then
		local name = data.name or p2

		if data.priceInRobux ~= nil then
			local priceInRobux = data.priceInRobux
			p3 = numberLocalization.localize(tostring(priceInRobux), LocalizationService.RobloxLocaleId)
		end

		if FFlagBuildExperienceMonetizationNativeUI then
			local formatted = object:Format(LocalizationStrings.AGENT_DEV_PRODUCT_PRICE, {
				PRICE = p3
			})

			if FFlagBuildExperienceMonetizationCardFixes then
				return `{formatted}\n{kindText(data, object)}`
			end

			return formatted
		else
			local v9 = { formatSummary(object, LocalizationStrings.AGENT_DEV_PRODUCT_CREATE, {
					NAME = name,
					PRICE = p3
				}) }

			if data.description ~= nil then
				table.insert(
					v9,
					formatSummary(object, LocalizationStrings.AGENT_DEV_PRODUCT_DESCRIPTION, {
						DESCRIPTION = data.description
					})
				)
			end

			return table.concat(v9, "\n")
		end
	elseif action == "update" then
		local productId = tostring(data.productId)
		local v9 = { formatSummary(object, LocalizationStrings.AGENT_DEV_PRODUCT_UPDATE, {
				PRODUCT_ID = productId
			}) }

		if data.name ~= nil then
			table.insert(v9, formatSummary(object, LocalizationStrings.AGENT_DEV_PRODUCT_NAME, {
				NAME = data.name
			}))
		end

		if data.description ~= nil then
			table.insert(
				v9,
				formatSummary(object, LocalizationStrings.AGENT_DEV_PRODUCT_DESCRIPTION, {
					DESCRIPTION = data.description
				})
			)
		end

		if data.priceInRobux ~= nil then
			local priceInRobux = data.priceInRobux
			local localize = numberLocalization.localize(
				tostring(priceInRobux),
				LocalizationService.RobloxLocaleId
			)

			table.insert(v9, formatSummary(object, LocalizationStrings.AGENT_DEV_PRODUCT_PRICE, {
				PRICE = localize
			}))
		end

		return table.concat(v9, "\n")
	else
		if action == "activate" then
			local productId = tostring(data.productId)
			return formatSummary(object, LocalizationStrings.AGENT_DEV_PRODUCT_ACTIVATE, {
				PRODUCT_ID = productId
			})
		end

		if action ~= "deactivate" then
			return formatSummary(object, LocalizationStrings.AGENT_DEV_PRODUCT_MANAGE, {})
		end

		local productId = tostring(data.productId)
		return formatSummary(object, LocalizationStrings.AGENT_DEV_PRODUCT_DEACTIVATE, {
			PRODUCT_ID = productId
		})
	end
end

local function itemSummaryText(data, p2, p3, p4)
	local action = data.action
	local v9 = if data.itemKind == nil then v6 else v7[data.itemKind] or v6

	if action == "create" then
		local name = data.name or p3

		if data.priceInRobux ~= nil then
			local priceInRobux = data.priceInRobux
			p4 = numberLocalization.localize(tostring(priceInRobux), LocalizationService.RobloxLocaleId)
		end

		local v10

		if FFlagBuildExperienceMonetizationNativeUI then
			v10 = { formatSummary(p2, LocalizationStrings.AGENT_DEV_PRODUCT_PRICE, { PRICE = p4 }) }
		else
			v10 = { formatSummary(p2, v9.create, { NAME = name, PRICE = p4 }) }
		end

		if FFlagBuildExperienceMonetizationCardFixes and FFlagBuildExperienceMonetizationNativeUI then
			table.insert(v10, kindText(data, p2))
		end

		appendSubscriptionProductType(v10, data, p2)

		if FFlagBuildExperienceMonetizationNativeUI then
			return table.concat(v10, "\n")
		end

		if data.description ~= nil then
			table.insert(
				v10,
				formatSummary(p2, LocalizationStrings.AGENT_DEV_PRODUCT_DESCRIPTION, {
					DESCRIPTION = data.description
				})
			)
		end

		return table.concat(v10, "\n")
	elseif action == "update" then
		local v10 = { formatSummary(p2, v9.update, {
				PRODUCT_ID = data.itemId or tostring(data.productId)
			}) }

		if data.name ~= nil then
			table.insert(v10, formatSummary(p2, LocalizationStrings.AGENT_DEV_PRODUCT_NAME, {
				NAME = data.name
			}))
		end

		if data.description ~= nil then
			table.insert(
				v10,
				formatSummary(p2, LocalizationStrings.AGENT_DEV_PRODUCT_DESCRIPTION, {
					DESCRIPTION = data.description
				})
			)
		end

		if data.priceInRobux ~= nil then
			local priceInRobux = data.priceInRobux
			local localize = numberLocalization.localize(
				tostring(priceInRobux),
				LocalizationService.RobloxLocaleId
			)

			table.insert(v10, formatSummary(p2, LocalizationStrings.AGENT_DEV_PRODUCT_PRICE, {
				PRICE = localize
			}))
		end

		return table.concat(v10, "\n")
	else
		local v10

		if not (data.action == "create" or data.action == "update" or data.action == "title") then
			if
				data.action == "deactivate"
				and data.cancelRenewals == true
				and v9.deactivateCancelRenewals ~= nil
			then
				v10 = v9.deactivateCancelRenewals
			else
				v10 = v9[data.action]
			end
		end

		if v10 == nil then
			return formatSummary(p2, LocalizationStrings.AGENT_DEV_PRODUCT_MANAGE, {})
		end

		return formatSummary(p2, v10, {
			PRODUCT_ID = data.itemId or tostring(data.productId)
		})
	end
end

local function summaryText(p2, p3, p4, p5)
	if FFlagCreatorAgentChatMonetizationToolHelpers or p2.itemKind ~= nil then
		return itemSummaryText(p2, p3, p4, p5)
	end

	return devProductSummaryText(p2, p3, p4, p5)
end

local function AgentDevProductCard(props)
	local v9 = React.useContext(localizationRoactContext)
	local v12 = if props.itemKind == nil then v6 else v7[props.itemKind] or v6

	local v11 = {
		title = v12.title,
		approve = LocalizationStrings.AGENT_DEV_PRODUCT_APPROVE,
		reject = 0,
		defaultName = 0,
		unavailablePrice = 0,
		preview = 0,
		create = 0,
		error = 0,
		retry = 0,
		imageInReview = 0,
		imagePreparing = 0,
		imageTooLarge = 0,
		imageTimedOut = 0,
		imageFailed = 0,
		moderated = 0,
		noUniverse = 0,
		rateLimited = 0
	}

	local v13 = if FFlagBuildExperienceMonetizationNativeUI then LocalizationStrings.MONETIZATION_CANCEL else LocalizationStrings.AGENT_DEV_PRODUCT_REJECT
	v11.reject = v13

	v11.defaultName = LocalizationStrings.AGENT_DEV_PRODUCT_DEFAULT_NAME
	v11.unavailablePrice = LocalizationStrings.AGENT_DEV_PRODUCT_PRICE_UNAVAILABLE

	local v14 = if FFlagBuildExperienceMonetizationNativeUI then LocalizationStrings.GAME_CONFIGURATION_PREVIEW else nil
	v11.preview = v14

	local v15 = if FFlagBuildExperienceMonetizationNativeUI then LocalizationStrings.MONETIZATION_EMPTY_CREATE_PRODUCT else nil
	v11.create = v15

	local v16 = if FFlagBuildExperienceDevProductRecovery then LocalizationStrings.BUILD_ELIGIBILITY_ERROR_TITLE else nil
	v11.error = v16

	local v17 = if FFlagBuildExperienceDevProductRecovery then LocalizationStrings.MONETIZATION_RETRY else nil
	v11.retry = v17

	local v18 = if FFlagBuildExperienceMonetizationFailureCauses then LocalizationStrings.MONETIZATION_CAUSE_IMAGE_IN_REVIEW else nil
	v11.imageInReview = v18

	local v19 = if FFlagBuildExperienceMonetizationFailureCauses then LocalizationStrings.MONETIZATION_CAUSE_IMAGE_PREPARING else nil
	v11.imagePreparing = v19

	local v20 = if FFlagBuildExperienceMonetizationFailureCauses then LocalizationStrings.MONETIZATION_CAUSE_IMAGE_TOO_LARGE else nil
	v11.imageTooLarge = v20

	local v21 = if FFlagBuildExperienceMonetizationFailureCauses then LocalizationStrings.MONETIZATION_CAUSE_IMAGE_TIMED_OUT else nil
	v11.imageTimedOut = v21

	local v22 = if FFlagBuildExperienceMonetizationFailureCauses then LocalizationStrings.MONETIZATION_CAUSE_IMAGE_FAILED else nil
	v11.imageFailed = v22

	local v23 = if FFlagBuildExperienceMonetizationFailureCauses then LocalizationStrings.MONETIZATION_MODERATION_ERROR else nil
	v11.moderated = v23

	local v24 = if FFlagBuildExperienceMonetizationFailureCauses then LocalizationStrings.MONETIZATION_CAUSE_NO_UNIVERSE else nil
	v11.noUniverse = v24

	local v25 = if FFlagBuildExperienceMonetizationFailureCauses then LocalizationStrings.MONETIZATION_CAUSE_RATE_LIMITED else nil
	v11.rateLimited = v25
	local v26 = useLocalization(v11)

	local testId = props.testId or "agent-dev-product-card"
	local v27 = FFlagBuildExperienceDevProductRecovery and props.isPending == true
	local v28 = FFlagBuildExperienceDevProductRecovery and props.canRetry == true
	local isReadOnly = props.isReadOnly == true
	local v29 = props.isActionDisabled == true or v27
	local v30 = v29 or isReadOnly
	local ref = if FFlagBuildExperienceDevProductRecovery then React.useRef(false) else nil
	local v31 = FFlagBuildExperienceMonetizationNativeUI and props.action == "create"
	local v32

	if FFlagBuildExperienceChatCardEmphasis then
		local v34 = if not v30 then ChatCardPriority.AgentProposal else nil
		v32 = useChatCardEmphasis(v34)
	end

	local state, v33, v34

	if FFlagBuildExperienceMonetizationNativeUI then
		local setState
		state, setState = React.useState(false)
		v33 = setState
		v34 = React.useCallback(function()
			if ref ~= nil then
				ref.current = false
			end

			v33(true)
		end, { v33 })
	else
		state = false
		v33 = nil
	end

	local v35

	if v31 then
		local createElement = React.createElement
		local root = sheet.Root
		local v36 = {
			isOpen = state,
			onClose = function()
				if not (FFlagBuildExperienceDevProductRecovery or state or v30) then
					props.onApprove()
				end

				v33(false)
			end,
			snapPoints = { 0.5, 1 },
			testId = `{testId}-preview`
		}
		local v37 = {
			Header = React.createElement(sheet.Header, nil, {
				Title = React.createElement(text, {
					Text = props.name or v26.defaultName,
					tag = "size-full-0 auto-y text-title-large text-wrap text-align-x-left content-emphasis"
				})
			}),
			Content = 0,
			Actions = 0
		}

		local createElement2 = React.createElement
		local content = sheet.Content
		local createElement3 = React.createElement

		local v42 = if props.imageAssetId == nil then React.createElement(image, {
			LayoutOrder = 1,
			Image = assetId,
			ScaleType = Enum.ScaleType.Fit,
			tag = "size-3000-3000 content-emphasis",
			testId = `{testId}-preview-image`
		}) else React.createElement(image, {
			LayoutOrder = 1,
			Image = `rbxassetid://{props.imageAssetId}`,
			ScaleType = Enum.ScaleType.Fit,
			tag = "size-3000-3000 radius-medium",
			testId = `{testId}-preview-image`
		})

		local createElement4 = React.createElement

		local defaultName = v26.defaultName
		local unavailablePrice = v26.unavailablePrice
		local v45 = if FFlagCreatorAgentChatMonetizationToolHelpers or props.itemKind ~= nil then itemSummaryText(props, v9, defaultName, unavailablePrice) else devProductSummaryText(
			props,
			v9,
			defaultName,
			unavailablePrice
		)

		v37.Content = createElement2(content, nil, {
			Details = createElement3(view, {
				tag = "col align-x-center gap-large size-full-0 auto-y"
			}, {
				Image = v42,
				Price = createElement4(text, {
					LayoutOrder = 2,
					Text = v45,
					tag = "size-full-0 auto-y text-body-large text-wrap text-align-x-left content-emphasis",
					testId = `{testId}-preview-summary`
				}),
				Description = React.createElement(text, {
					LayoutOrder = 3,
					Text = props.description or "",
					tag = "size-full-0 auto-y text-body-medium text-wrap text-align-x-left content-default",
					testId = `{testId}-preview-description`
				})
			})
		})
		local v46

		if not v30 then
			local createElement5 = React.createElement
			local actions = sheet.Actions
			local createElement6 = React.createElement
			local v51 = if v28 then v26.retry else v26.create
			v46 = createElement5(actions, nil, {
				Create = createElement6(button, {
					text = v51,
					size = inputSize.Large,
					variant = buttonVariant.Emphasis,
					fillBehavior = fillBehavior.Fill,
					isDisabled = not state,
					onActivated = function()
						if v30 or not state then
							return
						end

						if ref ~= nil then
							if ref.current then
								return
							end

							ref.current = true
							props.onApprove()
						end

						v33(false)
					end,
					testId = `{testId}-create-button`
				})
			})
		end

		v37.Actions = v46
		v35 = createElement(root, v36, v37)
	end

	local v36 = React.useCallback(function()
		if v30 then
			return
		end

		props.onApprove()
	end, { v30, props.onApprove })

	local v37 = React.useCallback(function()
		if v30 then
			return
		end

		props.onReject()
	end, { v30, props.onReject })

	local createElement = React.createElement
	local v39 = {
		layoutOrder = FFlagBuildExperienceDevProductRecovery and 5 or (v31 or props.imageAssetId == nil) and 3 or 4
	}

	local createElement2 = React.createElement

	local v43 = if v28 then v26.retry elseif v31 then v26.preview else v26.approve
	local v42 = {
		LayoutOrder = 1,
		text = v43,
		size = inputSize.Small,
		variant = 0,
		fillBehavior = 0,
		isDisabled = 0,
		onActivated = 0,
		testId = 0
	}
	local v44 = if v32 == false then buttonVariant.SoftEmphasis else buttonVariant.Emphasis
	v42.variant = v44
	v42.fillBehavior = fillBehavior.Fill
	local v45 = if v31 then v27 or isReadOnly else v30
	v42.isDisabled = v45

	if v31 then
		if v28 then
			v34 = v36
		end
	else
		v34 = v36
	end

	v42.onActivated = v34
	local v46 = if v31 then `{testId}-preview-button` else `{testId}-approve-button`
	v42.testId = v46
	local v40 = { Approve = createElement2(button, v42), Reject = 0 }

	local v47 = if not (v31 and v29) then React.createElement(button, {
		LayoutOrder = 2,
		text = v26.reject,
		size = inputSize.Small,
		variant = buttonVariant.Standard,
		fillBehavior = fillBehavior.Fill,
		isDisabled = v30,
		onActivated = v37,
		testId = `{testId}-reject-button`
	}) else nil
	v40.Reject = v47
	local element = createElement(AgentCardActions, v39, v40)
	local v48 = FFlagBuildExperienceMonetizationCardFixes and FFlagBuildExperienceMonetizationNativeUI and v31
	local createElement3 = React.createElement
	local v51

	if v48 then
		local defaultName = v26.defaultName
		local v52 = v26.unavailablePrice
		local AGENT_MONETIZATION_CREATE_TITLE = LocalizationStrings.AGENT_MONETIZATION_CREATE_TITLE
		local v53 = {
			NAME = props.name or defaultName,
			PRICE = 0
		}

		if props.priceInRobux ~= nil then
			local priceInRobux = props.priceInRobux
			v52 = numberLocalization.localize(tostring(priceInRobux), LocalizationService.RobloxLocaleId)
		end

		v53.PRICE = v52
		v51 = v9:Format(AGENT_MONETIZATION_CREATE_TITLE, v53)
	else
		v51 = if v31 then props.name or v26.defaultName else v26.title
	end

	local v50 = {
		title = v51,
		fitToContent = (v31 or FFlagBuildExperienceMonetizationCardFixes) and true or nil,
		textContent = 0,
		layoutOrder = 0,
		testId = 0,
		footer = 0
	}
	local v52

	if v48 then
		v52 = props.description or ""
	else
		local defaultName = v26.defaultName
		local unavailablePrice = v26.unavailablePrice

		if FFlagCreatorAgentChatMonetizationToolHelpers or props.itemKind ~= nil then
			v52 = itemSummaryText(props, v9, defaultName, unavailablePrice)
		else
			v52 = devProductSummaryText(props, v9, defaultName, unavailablePrice)
		end
	end

	v50.textContent = v52

	v50.layoutOrder = props.layoutOrder
	v50.testId = testId
	v50.footer = if FFlagBuildExperienceDevProductRecovery then element else nil

	local v55 = if not v31 and props.imageAssetId ~= nil then React.createElement(image, {
		LayoutOrder = 3,
		Image = `rbxassetid://{props.imageAssetId}`,
		ScaleType = Enum.ScaleType.Fit,
		tag = "size-3000-3000 radius-medium",
		testId = `{testId}-image-preview`
	}) else nil
	local v56

	if FFlagBuildExperienceDevProductRecovery and props.hasError and not v27 then
		local createElement4 = React.createElement

		local v59 = if props.errorCause ~= nil then v26[props.errorCause] else nil
		v56 = createElement4(text, {
			LayoutOrder = 4,
			Text = v59 or v26.error,
			tag = "size-full-0 auto-y text-body-medium text-wrap text-align-x-left content-alert",
			testId = `{testId}-error`
		})
	end

	if FFlagBuildExperienceDevProductRecovery then
		element = nil
	end

	return createElement3(AgentCard, v50, {
		Preview = v35,
		ImagePreview = v55,
		Error = v56,
		Actions = element
	})
end

return AgentDevProductCard
