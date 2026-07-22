local CorePackages = game:GetService("CorePackages")
local Players = game:GetService("Players")
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local t = require(CorePackages.Packages.t)
local RobloxTranslator = require(CorePackages.Workspace.Packages.RobloxTranslator)
local mutedError = require(CorePackages.Workspace.Packages.Loggers).mutedError
local ParentParent = script.Parent.Parent
local BasePublishPrompt = require(ParentParent.BasePublishPrompt)
local ObjectViewport = require(ParentParent.Common.ObjectViewport)
local LabeledTextBox = require(ParentParent.Common.LabeledTextBox)
local PublishInfoList = require(ParentParent.Common.PublishInfoList)
local MakeupPartGrid = require(ParentParent.Common.MakeupPartGrid)
local MakeupPreviewUtils = require(script.Parent.Parent.Parent.MakeupPreviewUtils)
local PurchasePrompt = require(CorePackages.Workspace.Packages.PurchasePrompt)
local PublishAssetAnalytics = PurchasePrompt.PublishAssetAnalytics
local Actions = script.Parent.Parent.Parent.Actions
local SetPromptVisibility = require(Actions.SetPromptVisibility)
local uDim = UDim.new(0, 20)
local v20 = Roact.PureComponent:extend("PublishMakeupLookPrompt")

v20.validateProps = t.strictInterface({
	screenSize = t.Vector2,
	accessoryInstance = t.optional(t.union(t.instanceIsA("Folder"), t.instanceIsA("Decal"))),
	makeupEntries = t.optional(t.table),
	guid = t.any,
	scopes = t.any,
	priceInRobux = t.optional(t.number),
	SetPromptVisibility = t.callback
})

function v20.init(p1) -- line: 47
	-- upvalues: Players (copy), PublishAssetAnalytics (copy), PurchasePrompt (copy), mutedError (copy)
	local LocalPlayer = Players.LocalPlayer

	assert(LocalPlayer, "LocalPlayer must not be nil")
	p1:setState({
		showingPreviewView = false,
		isNameValid = true,
		isDescValid = true,
		showTopScrim = false,
		purchasePromptReady = true,
		previewModel = nil,
		name = LocalPlayer.Name .. "'s Makeup",
		description = LocalPlayer.Name .. "'s Makeup"
	})

	function p1.openPreviewView() -- line: 62
		-- upvalues: PublishAssetAnalytics (copy), p1 (copy)
		PublishAssetAnalytics.sendButtonClicked(PublishAssetAnalytics.Section.BuyCreationPage, PublishAssetAnalytics.Element.Expand)
		p1:setState({
			showingPreviewView = true
		})
	end
	function p1.closePreviewView() -- line: 67
		-- upvalues: p1 (copy)
		p1:setState({
			showingPreviewView = false
		})
	end
	function p1.canSubmit() -- line: 71
		-- upvalues: p1 (copy)
		return p1.state.isNameValid and (p1.state.isDescValid and (p1.props.accessoryInstance ~= nil and p1.state.purchasePromptReady))
	end
	function p1.onSubmit() -- line: 78
		-- upvalues: PublishAssetAnalytics (copy), p1 (copy), PurchasePrompt (copy), mutedError (copy)
		PublishAssetAnalytics.sendButtonClicked(PublishAssetAnalytics.Section.BuyCreationPage, PublishAssetAnalytics.Element.Buy)

		local t1 = {
			name = p1.state.name,
			description = p1.state.description
		}

		if PurchasePrompt.initiateAvatarCreationFeePurchase then
			PurchasePrompt.initiateAvatarCreationFeePurchase(t1, p1.props.guid, p1.state.previewModel, p1.props.priceInRobux)

			return
		end

		mutedError("PurchasePrompt.initiateAvatarCreationFeePurchase is not available")
	end
	function p1.onNameUpdated(p2, p3) -- line: 98
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
	function p1.onDescriptionUpdated(p4, p5) -- line: 106
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
	function p1.onWindowStateChanged(p6) -- line: 114
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
	function p1.onPromptStateSetToNone() -- line: 128
		-- upvalues: p1 (copy)
		p1:setState({
			purchasePromptReady = true
		})
	end
end
function v20.updatePreviewModel(p7) -- line: 133
	-- upvalues: MakeupPreviewUtils (copy)
	local accessoryInstance = p7.props.accessoryInstance

	if not accessoryInstance or not accessoryInstance:IsA("Folder") then
		return
	end

	task.spawn(function() -- line: 139
		-- upvalues: MakeupPreviewUtils (copy), accessoryInstance (copy), p7 (copy)
		local v47 = MakeupPreviewUtils.compositeMakeupFolder(accessoryInstance)

		if not v47 or not p7.isMounted then
			return
		end

		local v48 = MakeupPreviewUtils.createMakeupHeadPreview(v47, Enum.AvatarAssetType.FaceMakeup)

		if v48 and p7.isMounted then
			local previewModel = p7.state.previewModel

			p7:setState({
				previewModel = v48
			}, function() -- line: 148
				-- upvalues: previewModel (copy)
				if previewModel then
					previewModel:Destroy()
				end
			end)
		end
	end)
end
function v20.didMount(p8) -- line: 157
	-- upvalues: PurchasePrompt (copy), mutedError (copy), PublishAssetAnalytics (copy)
	p8.isMounted = true
	p8:updatePreviewModel()
	p8.sentNameFieldTouched = false
	p8.sentDescriptionFieldTouched = false

	local windowStateChangedEvent = PurchasePrompt.windowStateChangedEvent
	local promptStateSetToNoneEvent = PurchasePrompt.promptStateSetToNoneEvent

	if windowStateChangedEvent and promptStateSetToNoneEvent then
		p8.windowStateChangedConnection = windowStateChangedEvent:Connect(p8.onWindowStateChanged)
		p8.promptStateSetToNoneConnection = promptStateSetToNoneEvent:Connect(p8.onPromptStateSetToNone)
	else
		mutedError("PurchasePrompt.windowStateChangedEvent or PurchasePrompt.promptStateSetToNoneEvent is not available")
	end

	PublishAssetAnalytics.sendPageLoad(PublishAssetAnalytics.Section.BuyCreationPage)
end
function v20.didUpdate(p9, p10) -- line: 178
	if p10.accessoryInstance ~= p9.props.accessoryInstance then
		p9:updatePreviewModel()
	end
end
function v20.willUnmount(p11) -- line: 184
	-- upvalues: mutedError (copy)
	p11.isMounted = false

	if p11.state.previewModel then
		p11.state.previewModel:Destroy()
	end

	if p11.windowStateChangedConnection then
		p11.windowStateChangedConnection:Disconnect()
	else
		mutedError("windowStateChangedConnection was not established")
	end

	if p11.promptStateSetToNoneConnection then
		p11.promptStateSetToNoneConnection:Disconnect()

		return
	end

	mutedError("promptStateSetToNoneConnection was not established")
end
function v20.renderPromptBody(p12) -- line: 204
	-- upvalues: Roact (copy), uDim (copy), ObjectViewport (copy), LabeledTextBox (copy), RobloxTranslator (copy), PublishInfoList (copy), MakeupPartGrid (copy)
	local previewModel = p12.state.previewModel
	local v35 = previewModel == nil

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
			useFullBodyCameraSettings = false,
			fieldOfView = 30,
			LayoutOrder = 1,
			openPreviewView = p12.openPreviewView,
			model = previewModel,
			isLoading = v35
		}),
		DescriptionInput = Roact.createElement(LabeledTextBox, {
			LayoutOrder = 2,
			centerText = false,
			maxLength = 1000,
			textBoxHeight = 104,
			labelText = RobloxTranslator:FormatByKey("CoreScripts.PublishAssetPrompt.Description"),
			defaultText = p12.state.description,
			onTextUpdated = p12.onDescriptionUpdated,
			invalidInputText = RobloxTranslator:FormatByKey("CoreScripts.PublishAssetPrompt.InvalidDescription")
		}),
		InfoList = Roact.createElement(PublishInfoList, {
			LayoutOrder = 3,
			typeName = RobloxTranslator:FormatByKey("Feature.Catalog.Label.Makeup")
		}),
		MakeupGrid = Roact.createElement(MakeupPartGrid, {
			LayoutOrder = 4,
			makeupFolder = p12.props.accessoryInstance,
			makeupEntries = p12.props.makeupEntries,
			name = p12.state.name,
			screenSize = p12.props.screenSize
		})
	})
end
function v20.render(p13) -- line: 250
	-- upvalues: Roact (copy), BasePublishPrompt (copy), RobloxTranslator (copy)
	return Roact.createElement(BasePublishPrompt, {
		delayInputSeconds = 3,
		promptBody = p13:renderPromptBody(),
		screenSize = p13.props.screenSize,
		showingPreviewView = p13.state.showingPreviewView,
		closePreviewView = p13.closePreviewView,
		asset = p13.state.previewModel,
		nameLabel = RobloxTranslator:FormatByKey("CoreScripts.PublishAssetPrompt.Name"),
		defaultName = p13.state.name,
		titleText = RobloxTranslator:FormatByKey("CoreScripts.PublishAvatarPrompt.BuyCreation"),
		onNameUpdated = p13.onNameUpdated,
		canSubmit = p13.canSubmit,
		onSubmit = p13.onSubmit,
		priceInRobux = p13.props.priceInRobux,
		showTopScrim = p13.state.showTopScrim
	})
end

local function mapStateToProps(p14) -- line: 269
	return {
		accessoryInstance = p14.promptRequest.promptInfo.accessoryInstance,
		guid = p14.promptRequest.promptInfo.guid,
		scopes = p14.promptRequest.promptInfo.scopes,
		priceInRobux = p14.promptRequest.promptInfo.priceInRobux,
		makeupEntries = p14.promptRequest.promptInfo.makeupEntries
	}
end
local function mapDispatchToProps(p15) -- line: 279
	-- upvalues: SetPromptVisibility (copy)
	return {
		SetPromptVisibility = function(p16) -- line: 281
			-- upvalues: p15 (copy), SetPromptVisibility (copy)
			p15(SetPromptVisibility(p16))
		end
	}
end

return RoactRodux.connect(mapStateToProps, mapDispatchToProps)(v20)
