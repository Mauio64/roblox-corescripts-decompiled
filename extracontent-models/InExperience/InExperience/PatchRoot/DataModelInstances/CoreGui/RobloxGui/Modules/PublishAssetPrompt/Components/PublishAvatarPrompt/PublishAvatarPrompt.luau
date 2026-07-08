local CorePackages = game:GetService("CorePackages")
local Players = game:GetService("Players")
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local t = require(CorePackages.Packages.t)
local RobloxTranslator = require(CorePackages.Workspace.Packages.RobloxTranslator)
local AvatarPartGrid = require(script.Parent.AvatarParts.AvatarPartGrid)
local withStyle = require(CorePackages.Packages.UIBlox).Style.withStyle
local mutedError = require(CorePackages.Workspace.Packages.Loggers).mutedError
local ParentParent = script.Parent.Parent
local BasePublishPrompt = require(ParentParent.BasePublishPrompt)
local ObjectViewport = require(ParentParent.Common.ObjectViewport)
local LabeledTextBox = require(ParentParent.Common.LabeledTextBox)
local PublishInfoList = require(ParentParent.Common.PublishInfoList)
local PurchasePrompt = require(CorePackages.Workspace.Packages.PurchasePrompt)
local PublishAssetAnalytics = PurchasePrompt.PublishAssetAnalytics
local Actions = script.Parent.Parent.Parent.Actions
local SetPromptVisibility = require(Actions.SetPromptVisibility)
local uDim = UDim.new(0, 20)
local v20 = Roact.PureComponent:extend("PublishAvatarPrompt")

v20.validateProps = t.strictInterface({
	screenSize = t.Vector2,
	humanoidModel = t.optional(t.instanceOf("Model")),
	guid = t.any,
	scopes = t.any,
	SetPromptVisibility = t.callback
})

function v20.init(p1) -- line: 50
	-- upvalues: Players (copy), PublishAssetAnalytics (copy), PurchasePrompt (copy), mutedError (copy)
	local LocalPlayer = Players.LocalPlayer

	assert(LocalPlayer, "LocalPlayer must not be nil")
	p1:setState({
		showingPreviewView = false,
		isNameValid = true,
		isDescValid = true,
		showTopScrim = false,
		purchasePromptReady = true,
		name = LocalPlayer.Name .. "'s Body",
		description = LocalPlayer.Name .. "'s Body"
	})

	function p1.openPreviewView() -- line: 65
		-- upvalues: PublishAssetAnalytics (copy), p1 (copy)
		PublishAssetAnalytics.sendButtonClicked(PublishAssetAnalytics.Section.BuyCreationPage, PublishAssetAnalytics.Element.Expand)
		p1:setState({
			showingPreviewView = true
		})
	end
	function p1.closePreviewView() -- line: 71
		-- upvalues: p1 (copy)
		p1:setState({
			showingPreviewView = false
		})
	end
	function p1.canSubmit() -- line: 78
		-- upvalues: p1 (copy)
		return p1.state.isNameValid and (p1.state.isDescValid and (p1.props.humanoidModel ~= nil and p1.state.purchasePromptReady))
	end
	function p1.onSubmit() -- line: 85
		-- upvalues: PublishAssetAnalytics (copy), p1 (copy), PurchasePrompt (copy), mutedError (copy)
		PublishAssetAnalytics.sendButtonClicked(PublishAssetAnalytics.Section.BuyCreationPage, PublishAssetAnalytics.Element.Buy)

		local t1 = {
			name = p1.state.name,
			description = p1.state.description
		}

		if PurchasePrompt.initiateAvatarCreationFeePurchase then
			PurchasePrompt.initiateAvatarCreationFeePurchase(t1, p1.props.guid, p1.props.humanoidModel, p1.props.priceInRobux)

			return
		end

		mutedError("PurchasePrompt.initiateAvatarCreationFeePurchase is not available")
	end
	function p1.onNameUpdated(p2, p3) -- line: 104
		-- upvalues: p1 (copy), PublishAssetAnalytics (copy)
		p1:setState({
			name = p2,
			isNameValid = p3
		})

		if not p1.sentNameFieldTouched then
			p1.sentNameFieldTouched = true
			PublishAssetAnalytics.sendFieldTouched(PublishAssetAnalytics.Section.BuyCreationPage, PublishAssetAnalytics.Element.Name)
		end
	end
	function p1.onDescriptionUpdated(p4, p5) -- line: 116
		-- upvalues: p1 (copy), PublishAssetAnalytics (copy)
		p1:setState({
			description = p4,
			isDescValid = p5
		})

		if not p1.sentDescriptionFieldTouched then
			p1.sentDescriptionFieldTouched = true
			PublishAssetAnalytics.sendFieldTouched(PublishAssetAnalytics.Section.BuyCreationPage, PublishAssetAnalytics.Element.Description)
		end
	end
	function p1.onWindowStateChanged(p6) -- line: 128
		-- upvalues: p1 (copy)
		local hasCompletedPurchase = p6.hasCompletedPurchase
		local isShown = p6.isShown

		if hasCompletedPurchase and not isShown then
			p1.props.SetPromptVisibility(false)

			return
		end

		p1:setState({
			showTopScrim = isShown
		})

		if isShown then
			p1:setState({
				purchasePromptReady = false
			})
		end
	end
	function p1.onPromptStateSetToNone() -- line: 153
		-- upvalues: p1 (copy)
		p1:setState({
			purchasePromptReady = true
		})
	end
end
function v20.didMount(p7) -- line: 160
	-- upvalues: PurchasePrompt (copy), mutedError (copy), PublishAssetAnalytics (copy)
	p7.sentNameFieldTouched = false
	p7.sentDescriptionFieldTouched = false

	local windowStateChangedEvent = PurchasePrompt.windowStateChangedEvent
	local promptStateSetToNoneEvent = PurchasePrompt.promptStateSetToNoneEvent

	if windowStateChangedEvent and promptStateSetToNoneEvent then
		p7.windowStateChangedConnection = windowStateChangedEvent:Connect(p7.onWindowStateChanged)
		p7.promptStateSetToNoneConnection = promptStateSetToNoneEvent:Connect(p7.onPromptStateSetToNone)
	else
		mutedError("PurchasePrompt.windowStateChangedEvent or PurchasePrompt.promptStateSetToNoneEvent is not available")
	end

	PublishAssetAnalytics.sendPageLoad(PublishAssetAnalytics.Section.BuyCreationPage)
end
function v20.willUnmount(p8) -- line: 179
	-- upvalues: mutedError (copy)
	if p8.windowStateChangedConnection then
		p8.windowStateChangedConnection:Disconnect()
	else
		mutedError("windowStateChangedConnection was not established")
	end

	if p8.promptStateSetToNoneConnection then
		p8.promptStateSetToNoneConnection:Disconnect()

		return
	end

	mutedError("promptStateSetToNoneConnection was not established")
end
function v20.renderPromptBody(p9) -- line: 193
	-- upvalues: withStyle (copy), Roact (copy), uDim (copy), ObjectViewport (copy), LabeledTextBox (copy), RobloxTranslator (copy), PublishInfoList (copy), AvatarPartGrid (copy)
	local v30 = p9.props.humanoidModel == nil

	return withStyle(function(_) -- line: 195
		-- upvalues: Roact (copy), uDim (copy), ObjectViewport (copy), p9 (copy), v30 (copy), LabeledTextBox (copy), RobloxTranslator (copy), PublishInfoList (copy), AvatarPartGrid (copy)
		return Roact.createFragment({
			UIListLayout = Roact.createElement("UIListLayout", {
				Padding = uDim,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				SortOrder = Enum.SortOrder.LayoutOrder,
				FillDirection = Enum.FillDirection.Vertical
			}),
			UIPadding = Roact.createElement("UIPadding", {
				PaddingBottom = uDim,
				PaddingTop = uDim
			}),
			EmbeddedPreview = Roact.createElement(ObjectViewport, {
				useFullBodyCameraSettings = true,
				fieldOfView = 30,
				LayoutOrder = 1,
				isHumanoidModel = true,
				openPreviewView = p9.openPreviewView,
				model = p9.props.humanoidModel,
				isLoading = v30
			}),
			DescriptionInput = Roact.createElement(LabeledTextBox, {
				LayoutOrder = 2,
				centerText = false,
				maxLength = 1000,
				textBoxHeight = 104,
				labelText = RobloxTranslator:FormatByKey("CoreScripts.PublishAssetPrompt.Description"),
				defaultText = p9.state.description,
				onTextUpdated = p9.onDescriptionUpdated,
				invalidInputText = RobloxTranslator:FormatByKey("CoreScripts.PublishAssetPrompt.InvalidDescription")
			}),
			InfoList = Roact.createElement(PublishInfoList, {
				LayoutOrder = 3,
				typeName = RobloxTranslator:FormatByKey("Feature.Catalog.Label.Body")
			}),
			AvatarPartGrid = Roact.createElement(AvatarPartGrid, {
				LayoutOrder = 4,
				humanoidModel = p9.props.humanoidModel,
				name = p9.state.name,
				screenSize = p9.props.screenSize
			})
		})
	end)
end
function v20.render(p11) -- line: 240
	-- upvalues: Players (copy), Roact (copy), BasePublishPrompt (copy), RobloxTranslator (copy)
	assert(Players, "Players must not be nil")

	return Roact.createElement(BasePublishPrompt, {
		delayInputSeconds = 3,
		promptBody = p11:renderPromptBody(),
		screenSize = p11.props.screenSize,
		showingPreviewView = p11.state.showingPreviewView,
		closePreviewView = p11.closePreviewView,
		asset = p11.props.humanoidModel,
		nameLabel = RobloxTranslator:FormatByKey("CoreScripts.PublishAvatarPrompt.BodyName"),
		defaultName = p11.state.name,
		titleText = RobloxTranslator:FormatByKey("CoreScripts.PublishAvatarPrompt.BuyCreation"),
		onNameUpdated = p11.onNameUpdated,
		canSubmit = p11.canSubmit,
		onSubmit = p11.onSubmit,
		priceInRobux = p11.props.priceInRobux,
		showTopScrim = p11.state.showTopScrim
	})
end

local function mapStateToProps(p12) -- line: 261
	return {
		humanoidModel = p12.promptRequest.promptInfo.humanoidModel,
		guid = p12.promptRequest.promptInfo.guid,
		scopes = p12.promptRequest.promptInfo.scopes,
		priceInRobux = p12.promptRequest.promptInfo.priceInRobux
	}
end
local function mapDispatchToProps(p13) -- line: 270
	-- upvalues: SetPromptVisibility (copy)
	return {
		SetPromptVisibility = function(p14) -- line: 272
			-- upvalues: p13 (copy), SetPromptVisibility (copy)
			p13(SetPromptVisibility(p14))
		end
	}
end

return RoactRodux.connect(mapStateToProps, mapDispatchToProps)(v20)
