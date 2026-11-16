local CorePackages = game:GetService("CorePackages")
local ExperienceAuthService = game:GetService("ExperienceAuthService")
local Players = game:GetService("Players")

local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local t = require(CorePackages.Packages.t)
local RobloxTranslator = require(CorePackages.Workspace.Packages.RobloxTranslator)

local UIBlox = require(CorePackages.Packages.UIBlox)
local Foundation = require(CorePackages.Packages.Foundation)
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local FoundationFontFaceMigration = Foundation.Utility.Flags.FoundationFontFaceMigration
local withStyle = UIBlox.Style.withStyle
local InteractiveAlert = UIBlox.App.Dialog.Alert.InteractiveAlert
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local RoactGamepad = require(CorePackages.Packages.RoactGamepad)

local LocalPlayer = Players.LocalPlayer

local NameTextBox = require(script.Parent.Common.NameTextBox)
local AssetDescriptionTextBox = require(script.Parent.AssetDescriptionTextBox)
local ImagePreview = require(script.Parent.ImagePreview)
local ObjectViewport = require(script.Parent.ObjectViewport)
local CloseOpenPrompt = require(script.Parent.Parent.Actions.CloseOpenPrompt)

local set = {
	[Enum.AssetType.TShirtAccessory] = true,
	[Enum.AssetType.ShirtAccessory] = true,
	[Enum.AssetType.PantsAccessory] = true,
	[Enum.AssetType.JacketAccessory] = true,
	[Enum.AssetType.SweaterAccessory] = true,
	[Enum.AssetType.ShortsAccessory] = true,
	[Enum.AssetType.LeftShoeAccessory] = true,
	[Enum.AssetType.RightShoeAccessory] = true,
	[Enum.AssetType.DressSkirtAccessory] = true,
	[Enum.AssetType.HairAccessory] = true
}

local defineFastFlag = game:DefineFastFlag("SendConsentDeniedOnCancel", false)
local engineFeature = game:GetEngineFeature("EnableImagePublish")

local extended = Roact.PureComponent:extend("PublishAssetPromptSingleStep")

extended.validateProps = t.strictInterface({
	screenSize = t.Vector2,
	assetInstance = t.Instance,
	assetType = t.enum(Enum.AssetType),
	guid = t.any,
	scopes = t.any,
	closePrompt = t.callback
})

function extended:getDefaultText()
	if self.props.assetType == Enum.AssetType.Model then
		return RobloxTranslator:FormatByKey("CoreScripts.PublishAssetPrompt.PackagesDefaultName", {
			RBX_NAME = LocalPlayer and LocalPlayer.Name or ""
		})
	end

	return ""
end

function extended:init()
	self.assetName = self:getDefaultText()
	self.assetDescription = self:getDefaultText()
	self.isNameValid = true
	self.isDescriptionValid = true

	function self.closePrompt()
		self.props.closePrompt()
	end

	function self.denyAndClose()
		ExperienceAuthService:ScopeCheckUIComplete(
			self.props.guid,
			self.props.scopes,
			Enum.ScopeCheckResult.ConsentDenied,
			{}
		)

		self.closePrompt()
	end

	function self.confirmAndUpload()
		if not self.isNameValid then
			return
		end

		local v = {}
		v.assetName = self.assetName
		v.assetDescription = self.assetDescription

		ExperienceAuthService:ScopeCheckUIComplete(
			self.props.guid,
			self.props.scopes,
			Enum.ScopeCheckResult.ConsentAccepted,
			v
		)

		self.closePrompt()
	end

	function self.onAssetNameUpdated(assetName, p)
		if not p then
			self.isNameValid = false

			return
		end

		self.assetName = assetName
		self.isNameValid = true
	end

	function self.onAssetDescriptionUpdated(assetDescription, isDescriptionValid)
		self.assetDescription = assetDescription
		self.isDescriptionValid = isDescriptionValid
	end

	self.nameTextBoxRef = Roact.createRef()
	self.descriptionTextBoxRef = Roact.createRef()
end

function extended:renderMiddle(data)
	return withStyle(function(props)
		local font = props.Font
		local theme = props.Theme

		local v = engineFeature

		if v then
			if self.props.assetType == Enum.AssetType.Image then
				v = self.props.assetInstance:IsA("Decal")
			else
				v = false
			end
		end

		local createElement = Roact.createElement
		local frame = RoactGamepad.Focusable.Frame
		local middleContentRefsByRef = {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, 150),
			defaultChild = self.nameTextBoxRef,
			[Roact.Ref] = self.middleContentRef
		}
		local children = {
			UISizeConstraint = Roact.createElement("UISizeConstraint", {
				MinSize = Vector2.new(200, 200)
			}),
			TopSection = 0,
			Disclaimer = 0
		}

		local createElement2 = Roact.createElement
		local v2 = { Size = UDim2.new(1, 0, 1, -50), BackgroundTransparency = 1 }

		local createElement3 = Roact.createElement
		local v3 = { Size = UDim2.new(0.4, 0, 1, 0), BackgroundTransparency = 1 }
		local imagePreview

		if v then
			imagePreview = Roact.createElement(ImagePreview, {
				imageContent = self.props.assetInstance.TextureContent,
				autoRotateSeconds = 6
			})
		end

		local objectViewport

		if not v then
			objectViewport = Roact.createElement(ObjectViewport, {
				model = self.props.assetInstance
			}) or nil
		end

		local children2 = {
			ViewportParent = createElement3("Frame", v3, {
				ImagePreview = imagePreview,
				ObjectViewport = objectViewport
			}),
			NameDescriptionFields = 0
		}

		local createElement4 = Roact.createElement
		local v4 = {
			Size = UDim2.new(0.6, -10, 1, 0),
			AnchorPoint = Vector2.new(1, 0),
			Position = UDim2.fromScale(1, 0),
			BackgroundTransparency = 1
		}

		local createElement5 = Roact.createElement
		local v5 = {
			Size = UDim2.new(1, 0, 0, 15),
			Font = 0,
			FontFace = 0,
			Text = 0,
			TextSize = 12,
			TextColor3 = 0,
			BackgroundTransparency = 1,
			TextXAlignment = 0
		}
		local font2

		if not FoundationFontFaceMigration then
			font2 = font.Body.Font
		end

		v5.Font = font2
		local fontFace

		if FoundationFontFaceMigration then
			fontFace = normalizeFontFace(props.Tokens.Typography.BodyLarge.Font)
		end

		v5.FontFace = fontFace

		v5.Text = data.name

		v5.TextColor3 = theme.TextDefault.Color

		v5.TextXAlignment = Enum.TextXAlignment.Left
		local children3 = {
			NameLabel = createElement5("TextLabel", v5),
			NameInput = Roact.createElement(NameTextBox, {
				Size = UDim2.new(1, 0, 0, 30),
				Position = UDim2.new(0, 0, 0, 15),
				onNameUpdated = self.onAssetNameUpdated,
				nameTextBoxRef = self.nameTextBoxRef,
				NextSelectionDown = self.descriptionTextBoxRef,
				defaultName = self.assetName
			}),
			DescriptionLabel = 0,
			DescriptionInput = 0
		}

		local createElement6 = Roact.createElement
		local v6 = {
			Size = UDim2.new(1, 0, 0, 15),
			Position = UDim2.new(0, 0, 0, 60),
			Font = 0,
			FontFace = 0,
			TextSize = 12,
			Text = 0,
			TextColor3 = 0,
			BackgroundTransparency = 1,
			TextXAlignment = 0
		}
		local font3

		if not FoundationFontFaceMigration then
			font3 = font.Body.Font
		end

		v6.Font = font3
		local fontFace2

		if FoundationFontFaceMigration then
			fontFace2 = normalizeFontFace(props.Tokens.Typography.BodyLarge.Font)
		end

		v6.FontFace = fontFace2

		v6.Text = data.description
		v6.TextColor3 = theme.TextDefault.Color

		v6.TextXAlignment = Enum.TextXAlignment.Left
		children3.DescriptionLabel = createElement6("TextLabel", v6)

		children3.DescriptionInput = Roact.createElement(AssetDescriptionTextBox, {
			Size = UDim2.new(1, 0, 0, 80),
			Position = UDim2.new(0, 0, 0, 75),
			onAssetDescriptionUpdated = self.onAssetDescriptionUpdated,
			descriptionTextBoxRef = self.descriptionTextBoxRef,
			NextSelectionUp = self.nameTextBoxRef,
			defaultDescription = self.assetDescription
		})
		children2.NameDescriptionFields = createElement4("Frame", v4, children3)
		children.TopSection = createElement2("Frame", v2, children2)

		local createElement7 = Roact.createElement
		local v7 = {
			Size = UDim2.new(1, 0, 0, 50),
			TextYAlignment = Enum.TextYAlignment.Center,
			Text = data.disclaimer,
			Font = 0,
			FontFace = 0,
			TextSize = 12,
			TextColor3 = 0,
			BackgroundTransparency = 1,
			AnchorPoint = 0,
			Position = 0,
			TextWrapped = true
		}
		local font4

		if not FoundationFontFaceMigration then
			font4 = font.Body.Font
		end

		v7.Font = font4
		local fontFace3

		if FoundationFontFaceMigration then
			fontFace3 = normalizeFontFace(props.Tokens.Typography.BodyLarge.Font)
		end

		v7.FontFace = fontFace3

		v7.TextColor3 = theme.TextEmphasis.Color

		v7.AnchorPoint = Vector2.new(0, 1)
		v7.Position = UDim2.fromScale(0, 1)
		children.Disclaimer = createElement7("TextLabel", v7)
		return createElement(frame, middleContentRefsByRef, children)
	end)
end

function extended:renderAlertLocalized(props)
	local createElement = Roact.createElement
	local v = {
		title = props.title,
		buttonStackInfo = 0,
		middleContent = 0,
		screenSize = 0,
		defaultChildRef = 0,
		isMiddleContentFocusable = true
	}
	local onActivated

	if defineFastFlag then
		onActivated = self.denyAndClose
	else
		onActivated = self.closePrompt
	end

	v.buttonStackInfo = {
		buttons = {
			{
				props = { onActivated = onActivated, text = props.cancel },
				isDefaultChild = true
			},
			{
				buttonType = ButtonType.PrimarySystem,
				props = {
					onActivated = self.confirmAndUpload,
					text = props.submit,
					isDelayedInput = true,
					enableInputDelayed = true,
					delayInputSeconds = 6
				},
				isDefaultChild = false
			}
		}
	}

	function v.middleContent()
		return self:renderMiddle(props)
	end

	v.screenSize = self.props.screenSize
	v.defaultChildRef = self.props.defaultChildRef
	return (createElement(InteractiveAlert, v))
end

local function IsLayeredClothingType(p): boolean -- 1 equivalent call inferred from this helper
	return set[p] == true
end

local function GetLocalizedStringsForAssetType(assetType)
	local localizedStringsForAssetType = {}
	localizedStringsForAssetType.name = RobloxTranslator:FormatByKey("CoreScripts.PublishAssetPrompt.Name")
	localizedStringsForAssetType.description = RobloxTranslator:FormatByKey("CoreScripts.PublishAssetPrompt.Description")
	localizedStringsForAssetType.invalidName = RobloxTranslator:FormatByKey("CoreScripts.PublishAssetPrompt.InvalidName")
	localizedStringsForAssetType.invalidDescription = RobloxTranslator:FormatByKey("CoreScripts.PublishAssetPrompt.InvalidDescription")
	localizedStringsForAssetType.cancel = RobloxTranslator:FormatByKey("CoreScripts.PublishAssetPrompt.Cancel")
	localizedStringsForAssetType.submit = RobloxTranslator:FormatByKey("CoreScripts.PublishAssetPrompt.Submit")

	if IsLayeredClothingType(assetType) then -- inferred equivalent call
		localizedStringsForAssetType.title = RobloxTranslator:FormatByKey("CoreScripts.PublishAssetPrompt.TitleTextClothing")
		localizedStringsForAssetType.disclaimer = RobloxTranslator:FormatByKey("CoreScripts.PublishAssetPrompt.DisclaimerAvatar")
	elseif assetType == Enum.AssetType.EmoteAnimation then
		localizedStringsForAssetType.title = RobloxTranslator:FormatByKey("CoreScripts.PublishAssetPrompt.TitleTextEmote")
		localizedStringsForAssetType.disclaimer = RobloxTranslator:FormatByKey("CoreScripts.PublishAssetPrompt.DisclaimerEmote")
	elseif assetType == Enum.AssetType.Model then
		localizedStringsForAssetType.title = RobloxTranslator:FormatByKey("CoreScripts.PublishAssetPrompt.TitleTextModel")
		localizedStringsForAssetType.disclaimer = RobloxTranslator:FormatByKey("CoreScripts.PublishAssetPrompt.DisclaimerModel")
	elseif assetType == Enum.AssetType.Package then
		localizedStringsForAssetType.title = RobloxTranslator:FormatByKey("CoreScripts.PublishAssetPrompt.TitleTextPackage")
		localizedStringsForAssetType.disclaimer = RobloxTranslator:FormatByKey("CoreScripts.PublishAssetPrompt.DisclaimerModel")
	elseif assetType == Enum.AssetType.Image then
		localizedStringsForAssetType.title = RobloxTranslator:FormatByKey("CoreScripts.PublishAssetPrompt.TitleTextImage")
		localizedStringsForAssetType.disclaimer = RobloxTranslator:FormatByKey("CoreScripts.PublishAssetPrompt.DisclaimerImage")
	end

	return localizedStringsForAssetType
end

function extended:render()
	return self:renderAlertLocalized(GetLocalizedStringsForAssetType(self.props.assetType))
end

local function mapStateToProps(p)
	return {
		assetInstance = p.promptRequest.promptInfo.assetInstance,
		assetType = p.promptRequest.promptInfo.assetType,
		guid = p.promptRequest.promptInfo.guid,
		scopes = p.promptRequest.promptInfo.scopes
	}
end

local function mapDispatchToProps(callback)
	return {
		closePrompt = function()
			return callback(CloseOpenPrompt())
		end
	}
end

return RoactRodux.connect(mapStateToProps, mapDispatchToProps)(extended)
