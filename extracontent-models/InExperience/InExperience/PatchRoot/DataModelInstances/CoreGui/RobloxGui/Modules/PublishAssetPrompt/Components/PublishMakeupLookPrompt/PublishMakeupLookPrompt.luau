local CorePackages = game:GetService("CorePackages")
local Players = game:GetService("Players")

local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local t = require(CorePackages.Packages.t)
local RobloxTranslator = require(CorePackages.Workspace.Packages.RobloxTranslator)
local Loggers = require(CorePackages.Workspace.Packages.Loggers)
local mutedError = Loggers.mutedError

local parent = script.Parent.Parent
local BasePublishPrompt = require(parent.BasePublishPrompt)
local ObjectViewport = require(parent.Common.ObjectViewport)
local LabeledTextBox = require(parent.Common.LabeledTextBox)
local PublishInfoList = require(parent.Common.PublishInfoList)
local MakeupPartGrid = require(parent.Common.MakeupPartGrid)
local MakeupPreviewUtils = require(script.Parent.Parent.Parent.MakeupPreviewUtils)
local GetFFlagUploadMakeupSupport = require(script.Parent.Parent.Parent.Flags.GetFFlagUploadMakeupSupport)
local PurchasePrompt = require(CorePackages.Workspace.Packages.PurchasePrompt)
local PublishAssetAnalytics = PurchasePrompt.PublishAssetAnalytics

local Actions = script.Parent.Parent.Parent.Actions
local SetPromptVisibility = require(Actions.SetPromptVisibility)

local udim = UDim.new(0, 20)

local extended = Roact.PureComponent:extend("PublishMakeupLookPrompt")

extended.validateProps = t.strictInterface({
	screenSize = t.Vector2,
	accessoryInstance = t.optional(t.union(t.instanceIsA("Folder"), t.instanceIsA("Decal"))),
	makeupEntries = t.optional(t.table),
	guid = t.any,
	scopes = t.any,
	priceInRobux = t.optional(t.number),
	SetPromptVisibility = t.callback
})

function extended:init()
	local localPlayer = Players.LocalPlayer
	assert(localPlayer, "LocalPlayer must not be nil")

	self:setState({
		showingPreviewView = false,
		name = localPlayer.Name .. "'s Makeup",
		isNameValid = true,
		description = localPlayer.Name .. "'s Makeup",
		isDescValid = true,
		showTopScrim = false,
		purchasePromptReady = true,
		previewModel = nil
	})

	function self.openPreviewView()
		PublishAssetAnalytics.sendButtonClicked(
			PublishAssetAnalytics.Section.BuyCreationPage,
			PublishAssetAnalytics.Element.Expand
		)
		self:setState({ showingPreviewView = true })
	end

	function self.closePreviewView()
		self:setState({ showingPreviewView = false })
	end

	function self.canSubmit()
		local v = self.state.isNameValid and self.state.isDescValid

		if v then
			if self.props.accessoryInstance == nil then
				return false
			end

			return self.state.purchasePromptReady
		end

		return v
	end

	function self.onSubmit()
		PublishAssetAnalytics.sendButtonClicked(
			PublishAssetAnalytics.Section.BuyCreationPage,
			PublishAssetAnalytics.Element.Buy
		)

		local v = { name = self.state.name, description = self.state.description }

		if PurchasePrompt.initiateAvatarCreationFeePurchase then
			PurchasePrompt.initiateAvatarCreationFeePurchase(
				v,
				self.props.guid,
				self.state.previewModel,
				self.props.priceInRobux
			)
		else
			mutedError("PurchasePrompt.initiateAvatarCreationFeePurchase is not available")
		end
	end

	function self.onNameUpdated(name, isNameValid)
		self:setState({ name = name, isNameValid = isNameValid })

		if not self.sentNameFieldTouched then
			self.sentNameFieldTouched = true
			PublishAssetAnalytics.sendFieldTouched(
				PublishAssetAnalytics.Section.BuyCreationPage,
				PublishAssetAnalytics.Element.Name
			)
		end
	end

	function self.onDescriptionUpdated(description, isDescValid)
		self:setState({ description = description, isDescValid = isDescValid })

		if not self.sentDescriptionFieldTouched then
			self.sentDescriptionFieldTouched = true
			PublishAssetAnalytics.sendFieldTouched(
				PublishAssetAnalytics.Section.BuyCreationPage,
				PublishAssetAnalytics.Element.Description
			)
		end
	end

	function self.onWindowStateChanged(p)
		local hasCompletedPurchase = p.hasCompletedPurchase
		local isShown = p.isShown

		if hasCompletedPurchase and not isShown then
			self.props.SetPromptVisibility(false)
			return
		end

		self:setState({ showTopScrim = isShown })

		if isShown then
			self:setState({ purchasePromptReady = false })
		end
	end

	function self.onPromptStateSetToNone()
		self:setState({ purchasePromptReady = true })
	end
end

function extended:updatePreviewModel()
	local accessoryInstance = self.props.accessoryInstance

	if accessoryInstance and accessoryInstance:IsA("Folder") then
		local makeupEntries = self.props.makeupEntries

		task.spawn(function()
			local compositeMakeupFolder = MakeupPreviewUtils.compositeMakeupFolder(accessoryInstance)
			local folderAccessories = MakeupPreviewUtils.getFolderAccessories(accessoryInstance, makeupEntries)

			if not compositeMakeupFolder and #folderAccessories == 0 or not self.isMounted then
				return
			end

			local makeupHeadPreview = MakeupPreviewUtils.createMakeupHeadPreview(
				compositeMakeupFolder,
				Enum.AvatarAssetType.FaceMakeup,
				folderAccessories
			)

			if makeupHeadPreview and self.isMounted then
				local previewModel = self.state.previewModel
				self:setState({ previewModel = makeupHeadPreview }, function()
					if previewModel then
						previewModel:Destroy()
					end
				end)
			end
		end)
	end
end

function extended:didMount()
	self.isMounted = true
	self:updatePreviewModel()
	self.sentNameFieldTouched = false
	self.sentDescriptionFieldTouched = false

	local windowStateChangedEvent = PurchasePrompt.windowStateChangedEvent
	local promptStateSetToNoneEvent = PurchasePrompt.promptStateSetToNoneEvent

	if windowStateChangedEvent and promptStateSetToNoneEvent then
		self.windowStateChangedConnection = windowStateChangedEvent:Connect(self.onWindowStateChanged)
		self.promptStateSetToNoneConnection = promptStateSetToNoneEvent:Connect(self.onPromptStateSetToNone)
	else
		mutedError("PurchasePrompt.windowStateChangedEvent or PurchasePrompt.promptStateSetToNoneEvent is not available")
	end

	PublishAssetAnalytics.sendPageLoad(PublishAssetAnalytics.Section.BuyCreationPage)
end

function extended:didUpdate(p)
	if p.accessoryInstance ~= self.props.accessoryInstance then
		self:updatePreviewModel()
	end
end

function extended:willUnmount()
	self.isMounted = false

	if self.state.previewModel then
		self.state.previewModel:Destroy()
	end

	if self.windowStateChangedConnection then
		self.windowStateChangedConnection:Disconnect()
	else
		mutedError("windowStateChangedConnection was not established")
	end

	if self.promptStateSetToNoneConnection then
		self.promptStateSetToNoneConnection:Disconnect()
	else
		mutedError("promptStateSetToNoneConnection was not established")
	end
end

function extended:renderPromptBody()
	local previewModel = self.state.previewModel
	local isLoading = previewModel == nil
	return Roact.createFragment({
		UIListLayout = Roact.createElement("UIListLayout", {
			Padding = udim,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			SortOrder = Enum.SortOrder.LayoutOrder,
			FillDirection = Enum.FillDirection.Vertical
		}),
		UIPadding = Roact.createElement("UIPadding", { PaddingBottom = udim, PaddingTop = udim }),
		EmbeddedPreview = Roact.createElement(ObjectViewport, {
			openPreviewView = self.openPreviewView,
			model = previewModel,
			isLoading = isLoading,
			useFullBodyCameraSettings = false,
			fieldOfView = 30,
			LayoutOrder = 1,
			isMakeupPreview = GetFFlagUploadMakeupSupport()
		}),
		DescriptionInput = Roact.createElement(LabeledTextBox, {
			LayoutOrder = 2,
			labelText = RobloxTranslator:FormatByKey("CoreScripts.PublishAssetPrompt.Description"),
			centerText = false,
			defaultText = self.state.description,
			maxLength = 1000,
			onTextUpdated = self.onDescriptionUpdated,
			textBoxHeight = 104,
			invalidInputText = RobloxTranslator:FormatByKey("CoreScripts.PublishAssetPrompt.InvalidDescription")
		}),
		InfoList = Roact.createElement(PublishInfoList, {
			typeName = RobloxTranslator:FormatByKey("Feature.Catalog.Label.Makeup"),
			LayoutOrder = 3
		}),
		MakeupGrid = Roact.createElement(MakeupPartGrid, {
			makeupFolder = self.props.accessoryInstance,
			makeupEntries = self.props.makeupEntries,
			name = self.state.name,
			LayoutOrder = 4,
			screenSize = self.props.screenSize
		})
	})
end

function extended:render()
	return Roact.createElement(BasePublishPrompt, {
		promptBody = self:renderPromptBody(),
		screenSize = self.props.screenSize,
		showingPreviewView = self.state.showingPreviewView,
		closePreviewView = self.closePreviewView,
		isMakeupPreview = GetFFlagUploadMakeupSupport(),
		asset = self.state.previewModel,
		nameLabel = RobloxTranslator:FormatByKey("CoreScripts.PublishAssetPrompt.Name"),
		defaultName = self.state.name,
		titleText = RobloxTranslator:FormatByKey("CoreScripts.PublishAvatarPrompt.BuyCreation"),
		onNameUpdated = self.onNameUpdated,
		canSubmit = self.canSubmit,
		onSubmit = self.onSubmit,
		delayInputSeconds = 3,
		priceInRobux = self.props.priceInRobux,
		showTopScrim = self.state.showTopScrim
	})
end

local function mapStateToProps(p)
	return {
		accessoryInstance = p.promptRequest.promptInfo.accessoryInstance,
		guid = p.promptRequest.promptInfo.guid,
		scopes = p.promptRequest.promptInfo.scopes,
		priceInRobux = p.promptRequest.promptInfo.priceInRobux,
		makeupEntries = p.promptRequest.promptInfo.makeupEntries
	}
end

local function mapDispatchToProps(callback)
	return {
		SetPromptVisibility = function(p)
			callback(SetPromptVisibility(p))
		end
	}
end

return RoactRodux.connect(mapStateToProps, mapDispatchToProps)(extended)
