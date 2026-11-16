local BuildExperience = script:FindFirstAncestor("BuildExperience")
local parent = BuildExperience.Parent

local Foundation = require(parent.Foundation)
local Localization = require(parent.Localization)
local React = require(parent.React)
require(BuildExperience.Chat.chatTypes)
local LocalizationStrings = require(BuildExperience.LocalizationStrings)
local FFlagBuildExperienceMonetizationNativeUI = require(BuildExperience.Flags.FFlagBuildExperienceMonetizationNativeUI)
local FFlagBuildExperienceDevProductRecovery = require(BuildExperience.Flags.FFlagBuildExperienceDevProductRecovery)

local FFlagCreatorAgentChatMonetizationToolHelpers = require(BuildExperience.Flags.FFlagCreatorAgentChatMonetizationToolHelpers)
local FoundationCloudAssets

if FFlagBuildExperienceMonetizationNativeUI then
	FoundationCloudAssets = require(parent.FoundationCloudAssets)
end

local LocalizationService = game:GetService("LocalizationService")
local LocalizationRoactContext = Localization.LocalizationRoactContext
local NumberLocalization = Localization.NumberLocalization
local useLocalization = Localization.Hooks.useLocalization

local AgentCard = require(script.Parent.AgentCard)
local AgentCardActions = require(script.Parent.AgentCardActions)
local ChatCardPriority = require(BuildExperience.Components.Chat.ChatCardEmphasis.ChatCardPriority)
local useChatCardEmphasis = require(BuildExperience.Components.Chat.ChatCardEmphasis.useChatCardEmphasis)
local FFlagBuildExperienceChatCardEmphasis = require(BuildExperience.Flags.FFlagBuildExperienceChatCardEmphasis)

local FFlagBuildExperienceMonetizationFailureCauses = require(BuildExperience.Flags.FFlagBuildExperienceMonetizationFailureCauses)

local FFlagBuildExperienceMonetizationCardFixes = require(BuildExperience.Flags.FFlagBuildExperienceMonetizationCardFixes)
local Button = Foundation.Button
local Image = Foundation.Image
local Sheet = Foundation.Sheet
local Text = Foundation.Text
local View = Foundation.View

local ButtonVariant = Foundation.Enums.ButtonVariant
local FillBehavior = Foundation.Enums.FillBehavior
local InputSize = Foundation.Enums.InputSize
local assetId

if FFlagBuildExperienceMonetizationNativeUI then
	FoundationCloudAssets.preloadAsset("pictograms/robux")
	assetId = FoundationCloudAssets.Assets["pictograms/robux"].assetId
else
	assetId = nil
end

local v = {
	title = LocalizationStrings.AGENT_DEV_PRODUCT_TITLE,
	create = LocalizationStrings.AGENT_DEV_PRODUCT_CREATE,
	update = LocalizationStrings.AGENT_DEV_PRODUCT_UPDATE,
	activate = LocalizationStrings.AGENT_DEV_PRODUCT_ACTIVATE,
	deactivate = LocalizationStrings.AGENT_DEV_PRODUCT_DEACTIVATE
}

local v2 = {
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

local v3 = {
	consumable = LocalizationStrings.AGENT_SUBSCRIPTION_PRODUCT_TYPE_CONSUMABLE,
	currency = LocalizationStrings.AGENT_SUBSCRIPTION_PRODUCT_TYPE_CURRENCY,
	durable = LocalizationStrings.AGENT_SUBSCRIPTION_PRODUCT_TYPE_DURABLE
}

local function summaryKeys(p)
	local v4

	if p.itemKind == nil then
		return v
	end

	v4 = v2[p.itemKind]
	return v4 or v
end

local function idActionKey(p, data) -- 1 equivalent call inferred from this helper
	if data.action == "create" or data.action == "update" or data.action == "title" then
		return nil
	end

	if data.action == "deactivate" and data.cancelRenewals == true and p.deactivateCancelRenewals ~= nil then
		return p.deactivateCancelRenewals
	end

	return p[data.action]
end

local function itemIdText(data) -- 2 equivalent calls inferred from this helper
	return data.itemId or tostring(data.productId)
end

local function formatSummary(object, p: string, p2) -- 1 equivalent call inferred from this helper
	return object:Format(p, p2)
end

local function formatPrice(priceInRobux: number) -- 5 equivalent calls inferred from this helper
	return NumberLocalization.localize(tostring(priceInRobux), LocalizationService.RobloxLocaleId)
end

local function kindText(data, object)
	local AGENT_SUBSCRIPTION_PRODUCT_TYPE = LocalizationStrings.AGENT_SUBSCRIPTION_PRODUCT_TYPE
	local v4

	if data.itemKind == nil then
		v4 = v
	else
		v4 = v2[data.itemKind] or v
	end

	return formatSummary(object, AGENT_SUBSCRIPTION_PRODUCT_TYPE, {
		PRODUCT_TYPE = object:Format(v4.title, {})
	})
end

local function createCardTitle(props, p, defaultName: string, unavailablePrice: string) -- 1 equivalent call inferred from this helper
	local AGENT_MONETIZATION_CREATE_TITLE = LocalizationStrings.AGENT_MONETIZATION_CREATE_TITLE
	local v4 = {
		NAME = props.name or defaultName,
		PRICE = 0
	}

	if props.priceInRobux ~= nil then
		unavailablePrice = formatPrice(props.priceInRobux) -- inferred equivalent call
	end

	v4.PRICE = unavailablePrice
	return formatSummary(p, AGENT_MONETIZATION_CREATE_TITLE, v4)
end

local function appendSubscriptionProductType(list, data, object)
	if data.itemKind ~= "subscription" or data.productType == nil then
		return
	end

	local v4 = v3[data.productType]

	if v4 == nil then
		return
	end

	table.insert(
		list,
		formatSummary(object, LocalizationStrings.AGENT_SUBSCRIPTION_PRODUCT_TYPE, {
			PRODUCT_TYPE = object:Format(v4, {})
		})
	)
end

local function devProductSummaryText(data, object, p: string, price: string)
	local action = data.action

	if action == "create" then
		local name = data.name or p

		if data.priceInRobux ~= nil then
			price = formatPrice(data.priceInRobux) -- inferred equivalent call
		end

		if FFlagBuildExperienceMonetizationNativeUI then
			local v4 = formatSummary(object, LocalizationStrings.AGENT_DEV_PRODUCT_PRICE, { -- inferred equivalent call
				PRICE = price
			})

			if FFlagBuildExperienceMonetizationCardFixes then
				return `{v4}\n{kindText(data, object)}`
			end

			return v4
		else
			local v4 = { formatSummary(object, LocalizationStrings.AGENT_DEV_PRODUCT_CREATE, {
					NAME = name,
					PRICE = price
				}) }

			if data.description ~= nil then
				table.insert(
					v4,
					formatSummary(object, LocalizationStrings.AGENT_DEV_PRODUCT_DESCRIPTION, {
						DESCRIPTION = data.description
					})
				)
			end

			return table.concat(v4, "\n")
		end
	elseif action == "update" then
		local productId = tostring(data.productId)
		local v4 = { formatSummary(object, LocalizationStrings.AGENT_DEV_PRODUCT_UPDATE, {
				PRODUCT_ID = productId
			}) }

		if data.name ~= nil then
			table.insert(v4, formatSummary(object, LocalizationStrings.AGENT_DEV_PRODUCT_NAME, {
				NAME = data.name
			}))
		end

		if data.description ~= nil then
			table.insert(
				v4,
				formatSummary(object, LocalizationStrings.AGENT_DEV_PRODUCT_DESCRIPTION, {
					DESCRIPTION = data.description
				})
			)
		end

		if data.priceInRobux ~= nil then
			local price2 = formatPrice(data.priceInRobux) -- inferred equivalent call
			table.insert(v4, formatSummary(object, LocalizationStrings.AGENT_DEV_PRODUCT_PRICE, {
				PRICE = price2
			}))
		end

		return table.concat(v4, "\n")
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

local function itemSummaryText(data, p, p2: string, price: string)
	local action = data.action
	local v4

	if data.itemKind == nil then
		v4 = v
	else
		v4 = v2[data.itemKind] or v
	end

	if action == "create" then
		local name = data.name or p2

		if data.priceInRobux ~= nil then
			price = formatPrice(data.priceInRobux) -- inferred equivalent call
		end

		local v5

		if FFlagBuildExperienceMonetizationNativeUI then
			v5 = { formatSummary(p, LocalizationStrings.AGENT_DEV_PRODUCT_PRICE, {
					PRICE = price
				}) }
		else
			v5 = { formatSummary(p, v4.create, { NAME = name, PRICE = price }) }
		end

		if FFlagBuildExperienceMonetizationCardFixes and FFlagBuildExperienceMonetizationNativeUI then
			table.insert(v5, kindText(data, p))
		end

		appendSubscriptionProductType(v5, data, p)

		if FFlagBuildExperienceMonetizationNativeUI then
			return table.concat(v5, "\n")
		end

		if data.description ~= nil then
			table.insert(
				v5,
				formatSummary(p, LocalizationStrings.AGENT_DEV_PRODUCT_DESCRIPTION, {
					DESCRIPTION = data.description
				})
			)
		end

		return table.concat(v5, "\n")
	elseif action == "update" then
		local v5 = { formatSummary(p, v4.update, { PRODUCT_ID = itemIdText(data) }) } -- inferred equivalent call

		if data.name ~= nil then
			table.insert(v5, formatSummary(p, LocalizationStrings.AGENT_DEV_PRODUCT_NAME, {
				NAME = data.name
			}))
		end

		if data.description ~= nil then
			table.insert(
				v5,
				formatSummary(p, LocalizationStrings.AGENT_DEV_PRODUCT_DESCRIPTION, {
					DESCRIPTION = data.description
				})
			)
		end

		if data.priceInRobux ~= nil then
			local price2 = formatPrice(data.priceInRobux) -- inferred equivalent call
			table.insert(v5, formatSummary(p, LocalizationStrings.AGENT_DEV_PRODUCT_PRICE, {
				PRICE = price2
			}))
		end

		return table.concat(v5, "\n")
	else
		local v5 = idActionKey(v4, data) -- inferred equivalent call

		if v5 == nil then
			return formatSummary(p, LocalizationStrings.AGENT_DEV_PRODUCT_MANAGE, {})
		end

		return formatSummary(p, v5, { PRODUCT_ID = itemIdText(data) }) -- inferred equivalent call
	end
end

local function summaryText(props, p, defaultName: string, unavailablePrice: string) -- 2 equivalent calls inferred from this helper
	if FFlagCreatorAgentChatMonetizationToolHelpers or props.itemKind ~= nil then
		return itemSummaryText(props, p, defaultName, unavailablePrice)
	end

	return devProductSummaryText(props, p, defaultName, unavailablePrice)
end

local function AgentDevProductCard(props)
	local v4 = React.useContext(LocalizationRoactContext)
	local v6

	if props.itemKind == nil then
		v6 = v
	else
		v6 = v2[props.itemKind] or v
	end

	local v5 = {
		title = v6.title,
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
	local reject

	if FFlagBuildExperienceMonetizationNativeUI then
		reject = LocalizationStrings.MONETIZATION_CANCEL
	else
		reject = LocalizationStrings.AGENT_DEV_PRODUCT_REJECT
	end

	v5.reject = reject

	v5.defaultName = LocalizationStrings.AGENT_DEV_PRODUCT_DEFAULT_NAME
	v5.unavailablePrice = LocalizationStrings.AGENT_DEV_PRODUCT_PRICE_UNAVAILABLE
	local preview

	if FFlagBuildExperienceMonetizationNativeUI then
		preview = LocalizationStrings.GAME_CONFIGURATION_PREVIEW
	end

	v5.preview = preview
	local create

	if FFlagBuildExperienceMonetizationNativeUI then
		create = LocalizationStrings.MONETIZATION_EMPTY_CREATE_PRODUCT
	end

	v5.create = create
	local err

	if FFlagBuildExperienceDevProductRecovery then
		err = LocalizationStrings.BUILD_ELIGIBILITY_ERROR_TITLE
	end

	v5.error = err
	local retry

	if FFlagBuildExperienceDevProductRecovery then
		retry = LocalizationStrings.MONETIZATION_RETRY
	end

	v5.retry = retry
	local imageInReview

	if FFlagBuildExperienceMonetizationFailureCauses then
		imageInReview = LocalizationStrings.MONETIZATION_CAUSE_IMAGE_IN_REVIEW
	end

	v5.imageInReview = imageInReview
	local imagePreparing

	if FFlagBuildExperienceMonetizationFailureCauses then
		imagePreparing = LocalizationStrings.MONETIZATION_CAUSE_IMAGE_PREPARING
	end

	v5.imagePreparing = imagePreparing
	local imageTooLarge

	if FFlagBuildExperienceMonetizationFailureCauses then
		imageTooLarge = LocalizationStrings.MONETIZATION_CAUSE_IMAGE_TOO_LARGE
	end

	v5.imageTooLarge = imageTooLarge
	local imageTimedOut

	if FFlagBuildExperienceMonetizationFailureCauses then
		imageTimedOut = LocalizationStrings.MONETIZATION_CAUSE_IMAGE_TIMED_OUT
	end

	v5.imageTimedOut = imageTimedOut
	local imageFailed

	if FFlagBuildExperienceMonetizationFailureCauses then
		imageFailed = LocalizationStrings.MONETIZATION_CAUSE_IMAGE_FAILED
	end

	v5.imageFailed = imageFailed
	local moderated

	if FFlagBuildExperienceMonetizationFailureCauses then
		moderated = LocalizationStrings.MONETIZATION_MODERATION_ERROR
	end

	v5.moderated = moderated
	local noUniverse

	if FFlagBuildExperienceMonetizationFailureCauses then
		noUniverse = LocalizationStrings.MONETIZATION_CAUSE_NO_UNIVERSE
	end

	v5.noUniverse = noUniverse
	local rateLimited

	if FFlagBuildExperienceMonetizationFailureCauses then
		rateLimited = LocalizationStrings.MONETIZATION_CAUSE_RATE_LIMITED
	end

	v5.rateLimited = rateLimited
	local v7 = useLocalization(v5)

	local testId = props.testId or "agent-dev-product-card"
	local v8 = FFlagBuildExperienceDevProductRecovery and props.isPending == true
	local v9 = FFlagBuildExperienceDevProductRecovery and props.canRetry == true
	local isReadOnly = props.isReadOnly == true
	local v10 = props.isActionDisabled == true or v8
	local isDisabled = v10 or isReadOnly
	local ref

	if FFlagBuildExperienceDevProductRecovery then
		ref = React.useRef(false)
	else
		ref = nil
	end

	local v11 = FFlagBuildExperienceMonetizationNativeUI and props.action == "create"
	local v12

	if FFlagBuildExperienceChatCardEmphasis then
		local v13

		if not isDisabled then
			v13 = ChatCardPriority.AgentProposal
		end

		v12 = useChatCardEmphasis(v13)
	end

	local state, v13, onActivated

	if FFlagBuildExperienceMonetizationNativeUI then
		local setState
		state, setState = React.useState(false)
		v13 = setState
		onActivated = React.useCallback(function()
			if ref ~= nil then
				ref.current = false
			end

			v13(true)
		end, { v13 })
	else
		state = false
		v13 = nil
	end

	local preview2

	if v11 then
		local createElement = React.createElement
		local root = Sheet.Root
		local v14 = {
			isOpen = state,
			onClose = function()
				if not (FFlagBuildExperienceDevProductRecovery or state or isDisabled) then
					props.onApprove()
				end

				v13(false)
			end,
			snapPoints = { 0.5, 1 },
			testId = `{testId}-preview`
		}
		local v15 = {
			Header = React.createElement(Sheet.Header, nil, {
				Title = React.createElement(Text, {
					Text = props.name or v7.defaultName,
					tag = "size-full-0 auto-y text-title-large text-wrap text-align-x-left content-emphasis"
				})
			}),
			Content = 0,
			Actions = 0
		}

		local createElement2 = React.createElement
		local content = Sheet.Content
		local createElement3 = React.createElement
		local image

		if props.imageAssetId == nil then
			image = React.createElement(Image, {
				LayoutOrder = 1,
				Image = assetId,
				ScaleType = Enum.ScaleType.Fit,
				tag = "size-3000-3000 content-emphasis",
				testId = `{testId}-preview-image`
			})
		else
			image = React.createElement(Image, {
				LayoutOrder = 1,
				Image = `rbxassetid://{props.imageAssetId}`,
				ScaleType = Enum.ScaleType.Fit,
				tag = "size-3000-3000 radius-medium",
				testId = `{testId}-preview-image`
			})
		end

		v15.Content = createElement2(content, nil, {
			Details = createElement3(View, {
				tag = "col align-x-center gap-large size-full-0 auto-y"
			}, {
				Image = image,
				Price = React.createElement(Text, {
					LayoutOrder = 2,
					Text = summaryText(props, v4, v7.defaultName, v7.unavailablePrice), -- inferred equivalent call
					tag = "size-full-0 auto-y text-body-large text-wrap text-align-x-left content-emphasis",
					testId = `{testId}-preview-summary`
				}),
				Description = React.createElement(Text, {
					LayoutOrder = 3,
					Text = props.description or "",
					tag = "size-full-0 auto-y text-body-medium text-wrap text-align-x-left content-default",
					testId = `{testId}-preview-description`
				})
			})
		})
		local actions2

		if not isDisabled then
			local createElement4 = React.createElement
			local actions = Sheet.Actions
			local createElement5 = React.createElement
			local text = if v9 then v7.retry else v7.create
			actions2 = createElement4(actions, nil, {
				Create = createElement5(Button, {
					text = text,
					size = InputSize.Large,
					variant = ButtonVariant.Emphasis,
					fillBehavior = FillBehavior.Fill,
					isDisabled = not state,
					onActivated = function()
						if isDisabled or not state then
							return
						end

						if ref ~= nil then
							if ref.current then
								return
							end

							ref.current = true
							props.onApprove()
						end

						v13(false)
					end,
					testId = `{testId}-create-button`
				})
			})
		end

		v15.Actions = actions2
		preview2 = createElement(root, v14, v15)
	end

	local v14 = React.useCallback(function()
		if isDisabled then
			return
		end

		props.onApprove()
	end, { isDisabled, props.onApprove })

	local onActivated2 = React.useCallback(function()
		if isDisabled then
			return
		end

		props.onReject()
	end, { isDisabled, props.onReject })

	local createElement = React.createElement
	local v15 = {
		layoutOrder = FFlagBuildExperienceDevProductRecovery and 5 or (v11 or props.imageAssetId == nil) and 3 or 4
	}

	local createElement2 = React.createElement
	local text

	if v9 then
		text = v7.retry
	else
		text = if v11 then v7.preview else v7.approve
	end

	local v16 = {
		LayoutOrder = 1,
		text = text,
		size = InputSize.Small,
		variant = 0,
		fillBehavior = 0,
		isDisabled = 0,
		onActivated = 0,
		testId = 0
	}
	local variant

	if v12 == false then
		variant = ButtonVariant.SoftEmphasis
	else
		variant = ButtonVariant.Emphasis
	end

	v16.variant = variant
	v16.fillBehavior = FillBehavior.Fill
	local isDisabled2

	if v11 then
		isDisabled2 = v8 or isReadOnly
	else
		isDisabled2 = isDisabled
	end

	v16.isDisabled = isDisabled2

	if v11 then
		if v9 then
			onActivated = v14
		end
	else
		onActivated = v14
	end

	v16.onActivated = onActivated
	local testId2

	if v11 then
		testId2 = `{testId}-preview-button`
	else
		testId2 = `{testId}-approve-button`
	end

	v16.testId = testId2
	local v17 = { Approve = createElement2(Button, v16), Reject = 0 }
	local reject2

	if not (v11 and v10) then
		reject2 = React.createElement(Button, {
			LayoutOrder = 2,
			text = v7.reject,
			size = InputSize.Small,
			variant = ButtonVariant.Standard,
			fillBehavior = FillBehavior.Fill,
			isDisabled = isDisabled,
			onActivated = onActivated2,
			testId = `{testId}-reject-button`
		})
	end

	v17.Reject = reject2
	local element = createElement(AgentCardActions, v15, v17)
	local v18 = FFlagBuildExperienceMonetizationCardFixes and FFlagBuildExperienceMonetizationNativeUI and v11
	local createElement3 = React.createElement
	local title

	if v18 then
		title = createCardTitle(props, v4, v7.defaultName, v7.unavailablePrice) -- inferred equivalent call
	elseif v11 then
		title = props.name or v7.defaultName
	else
		title = v7.title
	end

	local v19 = {
		title = title,
		fitToContent = (v11 or FFlagBuildExperienceMonetizationCardFixes) and true or nil,
		textContent = 0,
		layoutOrder = 0,
		testId = 0,
		footer = 0
	}
	local textContent

	if v18 then
		textContent = props.description or ""
	else
		textContent = summaryText(props, v4, v7.defaultName, v7.unavailablePrice) -- inferred equivalent call
	end

	v19.textContent = textContent

	v19.layoutOrder = props.layoutOrder
	v19.testId = testId
	local footer

	if FFlagBuildExperienceDevProductRecovery then
		footer = element
	end

	v19.footer = footer
	local imagePreview

	if not (v11 or props.imageAssetId == nil) then
		imagePreview = React.createElement(Image, {
			LayoutOrder = 3,
			Image = `rbxassetid://{props.imageAssetId}`,
			ScaleType = Enum.ScaleType.Fit,
			tag = "size-3000-3000 radius-medium",
			testId = `{testId}-image-preview`
		})
	end

	local err2

	if FFlagBuildExperienceDevProductRecovery and props.hasError and not v8 then
		local createElement4 = React.createElement
		local v20

		if props.errorCause ~= nil then
			v20 = v7[props.errorCause]
		end

		err2 = createElement4(Text, {
			LayoutOrder = 4,
			Text = v20 or v7.error,
			tag = "size-full-0 auto-y text-body-medium text-wrap text-align-x-left content-alert",
			testId = `{testId}-error`
		})
	end

	if FFlagBuildExperienceDevProductRecovery then
		element = nil
	end

	return createElement3(AgentCard, v19, {
		Preview = preview2,
		ImagePreview = imagePreview,
		Error = err2,
		Actions = element
	})
end

return AgentDevProductCard
