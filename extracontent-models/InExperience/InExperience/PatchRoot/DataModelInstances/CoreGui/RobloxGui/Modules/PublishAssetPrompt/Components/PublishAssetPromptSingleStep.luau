local CorePackages = game:GetService("CorePackages")
local ExperienceAuthService = game:GetService("ExperienceAuthService")
local Players = game:GetService("Players")
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local t = require(CorePackages.Packages.t)
local RobloxTranslator = require(CorePackages.Workspace.Packages.RobloxTranslator)
local UIBlox = require(CorePackages.Packages.UIBlox)
local withStyle = UIBlox.Style.withStyle
local InteractiveAlert = UIBlox.App.Dialog.Alert.InteractiveAlert
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local IconButton = UIBlox.App.Button.IconButton
local RoactGamepad = require(CorePackages.Packages.RoactGamepad)
local LocalPlayer = Players.LocalPlayer
local NameTextBox = require(script.Parent.Common.NameTextBox)
local AssetDescriptionTextBox = require(script.Parent.AssetDescriptionTextBox)
local ObjectViewport = require(script.Parent.ObjectViewport)
local PreviewViewport = require(script.Parent.Common.PreviewViewport)
local EmoteThumbnailView = require(script.Parent.EmoteThumbnailView)
local EmoteThumbnailEditor = require(script.Parent.EmoteThumbnailEditor)
local EmoteThumbnailParameters = require(script.Parent.EmoteThumbnailParameters)
local CloseOpenPrompt = require(script.Parent.Parent.Actions.CloseOpenPrompt)
local Images = UIBlox.App.ImageSet.Images
local v24 = Images["icons/actions/previewExpand"]
local v25 = Images["icons/actions/edit/edit"]
local t1 = {
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
local ParentParent = script.Parent.Parent
local GetFFlagValidateDescription = require(ParentParent.GetFFlagValidateDescription)
local v29 = game:DefineFastFlag("SendConsentDeniedOnCancel", false)
local EngineFeature = game:GetEngineFeature("EnableEmotePublish")
local v31 = Roact.PureComponent:extend("PublishAssetPromptSingleStep")

v31.validateProps = t.strictInterface({
	screenSize = t.Vector2,
	assetInstance = t.Instance,
	assetType = t.enum(Enum.AssetType),
	guid = t.any,
	scopes = t.any,
	closePrompt = t.callback
})

function v31.getDefaultText(p1) -- line: 92
	-- upvalues: RobloxTranslator (copy), LocalPlayer (copy)
	if p1.props.assetType == Enum.AssetType.Model then
		return RobloxTranslator:FormatByKey("CoreScripts.PublishAssetPrompt.PackagesDefaultName", {
			RBX_NAME = LocalPlayer and LocalPlayer.Name or ""
		})
	end

	return ""
end
function v31.init(p2) -- line: 102
	-- upvalues: EmoteThumbnailParameters (copy), ExperienceAuthService (copy), GetFFlagValidateDescription (copy), EngineFeature (copy), Roact (copy)
	p2.assetName = p2:getDefaultText()
	p2.assetDescription = p2:getDefaultText()
	p2.isNameValid = true
	p2.isDescriptionValid = true
	p2:setState({
		showingThumbnailEditor = false,
		showingAssetPreview = false,
		thumbnailParameters = EmoteThumbnailParameters.defaultParameters
	})

	function p2.closePrompt() -- line: 114
		-- upvalues: p2 (copy)
		p2.props.closePrompt()
	end
	function p2.openThumbnailEditor() -- line: 118
		-- upvalues: p2 (copy)
		p2:setState({
			showingThumbnailEditor = true
		})
	end
	function p2.closeThumbnailEditor() -- line: 124
		-- upvalues: p2 (copy)
		p2:setState({
			showingThumbnailEditor = false
		})
	end
	function p2.openAssetPreview() -- line: 130
		-- upvalues: p2 (copy)
		p2:setState({
			showingAssetPreview = true
		})
	end
	function p2.closeAssetPreview() -- line: 136
		-- upvalues: p2 (copy)
		p2:setState({
			showingAssetPreview = false
		})
	end
	function p2.updateThumbnailParameters(p3) -- line: 142
		-- upvalues: p2 (copy)
		p2:setState({
			thumbnailParameters = p3
		})
	end
	function p2.denyAndClose() -- line: 148
		-- upvalues: ExperienceAuthService (copy), p2 (copy)
		ExperienceAuthService:ScopeCheckUIComplete(p2.props.guid, p2.props.scopes, Enum.ScopeCheckResult.ConsentDenied, {})
		p2.closePrompt()
	end
	function p2.confirmAndUpload() -- line: 158
		-- upvalues: p2 (copy), GetFFlagValidateDescription (copy), EngineFeature (copy), EmoteThumbnailParameters (copy), ExperienceAuthService (copy)
		if not p2.isNameValid then
			return
		end

		if GetFFlagValidateDescription() and not p2.isDescriptionValid then
			return
		end

		local t2 = {
			assetName = p2.assetName,
			assetDescription = p2.assetDescription
		}

		if EngineFeature and p2.props.assetType == Enum.AssetType.EmoteAnimation then
			t2.emoteThumbnailParameters = EmoteThumbnailParameters.encodeAsATable(p2.state.thumbnailParameters)
		end

		ExperienceAuthService:ScopeCheckUIComplete(p2.props.guid, p2.props.scopes, Enum.ScopeCheckResult.ConsentAccepted, t2)
		p2.closePrompt()
	end
	function p2.onAssetNameUpdated(p4, p5) -- line: 188
		-- upvalues: p2 (copy)
		if p5 then
			p2.assetName = p4
			p2.isNameValid = true

			return
		end

		p2.isNameValid = false
	end
	function p2.onAssetDescriptionUpdated(p6, p7) -- line: 197
		-- upvalues: p2 (copy)
		p2.assetDescription = p6
		p2.isDescriptionValid = p7
	end

	p2.nameTextBoxRef = Roact.createRef()
	p2.descriptionTextBoxRef = Roact.createRef()
end
function v31.renderMiddle(p8, p9) -- line: 206
	-- upvalues: withStyle (copy), EngineFeature (copy), Roact (copy), RoactGamepad (copy), ObjectViewport (copy), EmoteThumbnailView (copy), IconButton (copy), v24 (copy), v25 (copy), NameTextBox (copy), AssetDescriptionTextBox (copy)
	return withStyle(function(p10) -- line: 207
		-- upvalues: EngineFeature (copy), p8 (copy), Roact (copy), RoactGamepad (copy), ObjectViewport (copy), EmoteThumbnailView (copy), IconButton (copy), v24 (copy), v25 (copy), p9 (copy), NameTextBox (copy), AssetDescriptionTextBox (copy)
		local p10Font = p10.Font
		local Theme = p10.Theme
		local v58 = EngineFeature and (p8.props.assetType == Enum.AssetType.EmoteAnimation and p8.props.assetInstance:IsA("AnimationClip"))

		return Roact.createElement(RoactGamepad.Focusable.Frame, {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, 150),
			defaultChild = p8.nameTextBoxRef,
			[Roact.Ref] = p8.middleContentRef
		}, {
			UISizeConstraint = Roact.createElement("UISizeConstraint", {
				MinSize = Vector2.new(200, 200)
			}),
			TopSection = Roact.createElement("Frame", {
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 1, -50)
			}, {
				ViewportParent = Roact.createElement("Frame", {
					BackgroundTransparency = 1,
					Size = UDim2.new(0.4, 0, 1, 0)
				}, {
					ObjectViewport = not v58 and Roact.createElement(ObjectViewport, {
						model = p8.props.assetInstance
					}) or nil,
					EmoteThumbnailParent = v58 and Roact.createElement("Frame", {
						BackgroundTransparency = 1,
						Size = UDim2.fromScale(1, 1)
					}, {
						AspectRatioConstraint = Roact.createElement("UIAspectRatioConstraint", {
							AspectRatio = 1,
							AspectType = Enum.AspectType.FitWithinMaxSize,
							DominantAxis = Enum.DominantAxis.Width
						}),
						EmoteThumbnailView = Roact.createElement(EmoteThumbnailView, {
							animationClip = p8.props.assetInstance,
							thumbnailParameters = p8.state.thumbnailParameters
						}),
						PreviewButton = Roact.createElement(IconButton, {
							showBackground = true,
							position = UDim2.new(1, -2, 1, -2),
							anchorPoint = Vector2.new(1, 1),
							icon = v24,
							size = UDim2.new(0, 30, 0, 30),
							onActivated = p8.openAssetPreview
						}),
						EditButton = Roact.createElement(IconButton, {
							showBackground = true,
							position = UDim2.new(0, 2, 1, -2),
							anchorPoint = Vector2.new(0, 1),
							icon = v25,
							size = UDim2.new(0, 30, 0, 30),
							onActivated = p8.openThumbnailEditor
						})
					}) or nil
				}),
				NameDescriptionFields = Roact.createElement("Frame", {
					BackgroundTransparency = 1,
					Size = UDim2.new(0.6, -10, 1, 0),
					AnchorPoint = Vector2.new(1, 0),
					Position = UDim2.fromScale(1, 0)
				}, {
					NameLabel = Roact.createElement("TextLabel", {
						TextSize = 12,
						BackgroundTransparency = 1,
						Size = UDim2.new(1, 0, 0, 15),
						Font = p10Font.Body.Font,
						Text = p9.name,
						TextColor3 = Theme.TextDefault.Color,
						TextXAlignment = Enum.TextXAlignment.Left
					}),
					NameInput = Roact.createElement(NameTextBox, {
						Size = UDim2.new(1, 0, 0, 30),
						Position = UDim2.new(0, 0, 0, 15),
						onNameUpdated = p8.onAssetNameUpdated,
						nameTextBoxRef = p8.nameTextBoxRef,
						NextSelectionDown = p8.descriptionTextBoxRef,
						defaultName = p8.assetName
					}),
					DescriptionLabel = Roact.createElement("TextLabel", {
						TextSize = 12,
						BackgroundTransparency = 1,
						Size = UDim2.new(1, 0, 0, 15),
						Position = UDim2.new(0, 0, 0, 60),
						Font = p10Font.Body.Font,
						Text = p9.description,
						TextColor3 = Theme.TextDefault.Color,
						TextXAlignment = Enum.TextXAlignment.Left
					}),
					DescriptionInput = Roact.createElement(AssetDescriptionTextBox, {
						Size = UDim2.new(1, 0, 0, 80),
						Position = UDim2.new(0, 0, 0, 75),
						onAssetDescriptionUpdated = p8.onAssetDescriptionUpdated,
						descriptionTextBoxRef = p8.descriptionTextBoxRef,
						NextSelectionUp = p8.nameTextBoxRef,
						defaultDescription = p8.assetDescription
					})
				})
			}),
			Disclaimer = Roact.createElement("TextLabel", {
				TextSize = 12,
				BackgroundTransparency = 1,
				TextWrapped = true,
				Size = UDim2.new(1, 0, 0, 50),
				Text = p9.disclaimer,
				Font = p10Font.Body.Font,
				TextColor3 = Theme.TextEmphasis.Color,
				AnchorPoint = Vector2.new(0, 1),
				Position = UDim2.fromScale(0, 1)
			})
		})
	end)
end
function v31.renderAlertLocalized(p11, p12) -- line: 332
	-- upvalues: Roact (copy), InteractiveAlert (copy), v29 (copy), ButtonType (copy), EngineFeature (copy), EmoteThumbnailEditor (copy), PreviewViewport (copy)
	local v42 = Roact.createElement(InteractiveAlert, {
		isMiddleContentFocusable = true,
		title = p12.title,
		buttonStackInfo = {
			buttons = {
				{
					isDefaultChild = true,
					props = {
						onActivated = if not v29 then p11.closePrompt else p11.denyAndClose,
						text = p12.cancel
					}
				},
				{
					isDefaultChild = false,
					buttonType = ButtonType.PrimarySystem,
					props = {
						isDelayedInput = true,
						enableInputDelayed = true,
						delayInputSeconds = 3,
						onActivated = p11.confirmAndUpload,
						text = p12.submit
					}
				}
			}
		},
		middleContent = function() -- line: 357
			-- upvalues: p11 (copy), p12 (copy)
			return p11:renderMiddle(p12)
		end,
		screenSize = p11.props.screenSize,
		defaultChildRef = p11.props.defaultChildRef
	})

	if EngineFeature then
		return Roact.createFragment({
			Prompt = v42,
			ThumbnailEditor = p11.state.showingThumbnailEditor and Roact.createElement(EmoteThumbnailEditor, {
				animationClip = p11.props.assetInstance,
				initialThumbnailParameters = p11.state.thumbnailParameters,
				screenSize = p11.props.screenSize,
				updateThumbnailCallback = p11.updateThumbnailParameters,
				closePromptCallback = p11.closeThumbnailEditor
			}) or nil,
			PreviewFrame = p11.state.showingAssetPreview and Roact.createElement("Frame", {
				BackgroundTransparency = 0,
				Size = UDim2.new(0.5, 0, 0.5, 0),
				BackgroundColor3 = Color3.new(0.2, 0.2, 0.2),
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.fromScale(0.5, 0.5)
			}, {
				PreviewViewport = Roact.createElement(PreviewViewport, {
					asset = p11.props.assetInstance,
					closePreviewView = p11.closeAssetPreview
				})
			}) or nil
		})
	end

	return v42
end

local function IsLayeredClothingType(p13) -- line: 395
	-- upvalues: t1 (copy)
	if t1[p13] == true then
		return true
	end

	return false
end
local function GetLocalizedStringsForAssetType(p14) -- line: 403
	-- upvalues: RobloxTranslator (copy), t1 (copy)
	local t3 = {
		name = RobloxTranslator:FormatByKey("CoreScripts.PublishAssetPrompt.Name"),
		description = RobloxTranslator:FormatByKey("CoreScripts.PublishAssetPrompt.Description"),
		invalidName = RobloxTranslator:FormatByKey("CoreScripts.PublishAssetPrompt.InvalidName"),
		invalidDescription = RobloxTranslator:FormatByKey("CoreScripts.PublishAssetPrompt.InvalidDescription"),
		cancel = RobloxTranslator:FormatByKey("CoreScripts.PublishAssetPrompt.Cancel"),
		submit = RobloxTranslator:FormatByKey("CoreScripts.PublishAssetPrompt.Submit")
	}

	if t1[p14] == true then
		t3.title = RobloxTranslator:FormatByKey("CoreScripts.PublishAssetPrompt.TitleTextClothing")
		t3.disclaimer = RobloxTranslator:FormatByKey("CoreScripts.PublishAssetPrompt.DisclaimerAvatar")

		return t3
	end

	if p14 == Enum.AssetType.EmoteAnimation then
		t3.title = RobloxTranslator:FormatByKey("CoreScripts.PublishAssetPrompt.TitleTextEmote")
		t3.disclaimer = RobloxTranslator:FormatByKey("CoreScripts.PublishAssetPrompt.DisclaimerEmote")

		return t3
	end

	if p14 == Enum.AssetType.Model then
		t3.title = RobloxTranslator:FormatByKey("CoreScripts.PublishAssetPrompt.TitleTextModel")
		t3.disclaimer = RobloxTranslator:FormatByKey("CoreScripts.PublishAssetPrompt.DisclaimerModel")

		return t3
	end

	if p14 == Enum.AssetType.Package then
		t3.title = RobloxTranslator:FormatByKey("CoreScripts.PublishAssetPrompt.TitleTextPackage")
		t3.disclaimer = RobloxTranslator:FormatByKey("CoreScripts.PublishAssetPrompt.DisclaimerModel")
	end

	return t3
end

function v31.render(p15) -- line: 432
	-- upvalues: GetLocalizedStringsForAssetType (copy)
	return p15:renderAlertLocalized((GetLocalizedStringsForAssetType(p15.props.assetType)))
end

local function mapStateToProps(p16) -- line: 437
	return {
		assetInstance = p16.promptRequest.promptInfo.assetInstance,
		assetType = p16.promptRequest.promptInfo.assetType,
		guid = p16.promptRequest.promptInfo.guid,
		scopes = p16.promptRequest.promptInfo.scopes
	}
end
local function mapDispatchToProps(p17) -- line: 446
	-- upvalues: CloseOpenPrompt (copy)
	return {
		closePrompt = function() -- line: 448
			-- upvalues: p17 (copy), CloseOpenPrompt (copy)
			return p17(CloseOpenPrompt())
		end
	}
end

return RoactRodux.connect(mapStateToProps, mapDispatchToProps)(v31)
