local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local ContextActionService = game:GetService("ContextActionService")
local TweenService = game:GetService("TweenService")
local RobloxGui = CoreGui:WaitForChild("RobloxGui")
local TextService = game:GetService("TextService")
local GuiService = game:GetService("GuiService")
local LocalizationService = game:GetService("LocalizationService")
local VRService = game:GetService("VRService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local AppCommonLib = require(CorePackages.Workspace.Packages.AppCommonLib)
local Create = AppCommonLib.Create
local CoreScriptsCommon = require(CorePackages.Workspace.Packages.CoreScriptsCommon)
local MouseIconOverrideService = CoreScriptsCommon.MouseIconOverrideService
local CoreScriptsCommon2 = require(CorePackages.Workspace.Packages.CoreScriptsCommon)
local Constants = CoreScriptsCommon2.Constants
local Shimmer = require(RobloxGui.Modules.Shimmer)
local GetFFlagDisplayChannelNameOnErrorPrompt = require(RobloxGui.Modules.Flags.GetFFlagDisplayChannelNameOnErrorPrompt)

local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagLuaSupportMicroGamepadPreferredInput = SharedFlags.FFlagLuaSupportMicroGamepadPreferredInput
local InExperienceLocales = require(CorePackages.Workspace.Packages.InExperienceLocales)
local Localization = InExperienceLocales.Localization

local fFlag = settings():GetFFlag("LocalizeErrorCodeString")

local tweenInfo = TweenInfo.new(0.15, Enum.EasingStyle.Quint, Enum.EasingDirection.InOut, 0, false, 0)

local v = Localization.new(LocalizationService.RobloxLocaleId)

local function attemptTranslate(p, p2, p3) -- 3 equivalent calls inferred from this helper
	local success, result = pcall(function()
		return v:Format(p, p3)
	end)
	return success and result or p2
end

local v2 = {
	Default = function()
		return Create("Frame")({
			Name = "ErrorPrompt",
			BackgroundTransparency = 0,
			BorderSizePixel = 0,
			BackgroundColor3 = Constants.COLORS.FLINT,
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.new(0.5, 0, 0.5, 0),
			Size = UDim2.new(0, Constants.ERROR_PROMPT_MAX_WIDTH.Default, 0, Constants.ERROR_PROMPT_HEIGHT.Default),
			Visible = false,
			AutoLocalize = false,
			ZIndex = 8,
			Create("UIListLayout")({
				Name = "PromptLayout",
				SortOrder = Enum.SortOrder.LayoutOrder,
				HorizontalAlignment = Enum.HorizontalAlignment.Center
			}),
			Create("UIScale")({ Name = "PromptScale", Scale = 0 }),
			Create("Frame")({
				Name = "TitleFrame",
				LayoutOrder = 1,
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 0, Constants.ERROR_TITLE_FRAME_HEIGHT.Default),
				BorderSizePixel = 0,
				ZIndex = 8,
				Create("UIPadding")({
					Name = "TitleFramePadding",
					PaddingBottom = UDim.new(0, 11),
					PaddingTop = UDim.new(0, 11)
				}),
				Create("TextLabel")({
					Name = "ErrorTitle",
					TextColor3 = Constants.COLORS.WHITE,
					TextSize = 25,
					Size = UDim2.new(1, 0, 0, 28),
					BackgroundTransparency = 1,
					Font = Enum.Font.SourceSansSemibold,
					TextXAlignment = Enum.TextXAlignment.Center,
					TextYAlignment = Enum.TextYAlignment.Center,
					ZIndex = 8
				})
			}),
			Create("Frame")({
				Name = "SplitLine",
				LayoutOrder = 2,
				Size = UDim2.new(1, -2 * Constants.SIDE_PADDING, 0, Constants.SPLIT_LINE_THICKNESS),
				BackgroundColor3 = Constants.COLORS.PUMICE,
				BorderSizePixel = 0,
				ZIndex = 8
			}),
			Create("Frame")({
				Name = "MessageArea",
				LayoutOrder = 3,
				Size = UDim2.new(1, 0, 1, -Constants.ERROR_TITLE_FRAME_HEIGHT.Default - Constants.SPLIT_LINE_THICKNESS),
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				ZIndex = 8,
				Create("UIPadding")({
					Name = "MessageAreaPadding",
					PaddingBottom = UDim.new(0, Constants.SIDE_PADDING),
					PaddingLeft = UDim.new(0, Constants.SIDE_PADDING),
					PaddingRight = UDim.new(0, Constants.SIDE_PADDING),
					PaddingTop = UDim.new(0, Constants.SIDE_PADDING)
				}),
				Create("Frame")({
					Name = "ErrorFrame",
					BackgroundTransparency = 1,
					Size = UDim2.new(1, 0, 1, 0),
					ZIndex = 8,
					Create("UIListLayout")({
						Name = "ErrorFrameLayout",
						Padding = UDim.new(0, Constants.LAYOUT_PADDING),
						HorizontalAlignment = Enum.HorizontalAlignment.Center,
						SortOrder = Enum.SortOrder.LayoutOrder
					}),
					Create("TextLabel")({
						Name = "ErrorMessage",
						LayoutOrder = 1,
						Size = UDim2.new(1, 0, 1, -Constants.BUTTON_HEIGHT - Constants.LAYOUT_PADDING),
						TextSize = 20,
						TextColor3 = Constants.COLORS.PUMICE,
						ZIndex = 8,
						BackgroundTransparency = 1,
						TextWrapped = true,
						Font = Enum.Font.SourceSans
					}),
					Create("Frame")({
						Name = "ButtonArea",
						BackgroundTransparency = 1,
						Size = UDim2.new(1, 0, 0, Constants.BUTTON_HEIGHT),
						ZIndex = 8,
						LayoutOrder = 2,
						SelectionGroup = true,
						SelectionBehaviorUp = Enum.SelectionBehavior.Stop,
						SelectionBehaviorDown = Enum.SelectionBehavior.Stop,
						SelectionBehaviorLeft = Enum.SelectionBehavior.Stop,
						SelectionBehaviorRight = Enum.SelectionBehavior.Stop,
						Create("UIGridLayout")({
							Name = "ButtonLayout",
							CellPadding = UDim2.new(0, Constants.BUTTON_CELL_PADDING, 0, 0),
							CellSize = UDim2.new(1, 0, 0, Constants.BUTTON_HEIGHT),
							HorizontalAlignment = Enum.HorizontalAlignment.Center,
							VerticalAlignment = Enum.VerticalAlignment.Center,
							SortOrder = Enum.SortOrder.LayoutOrder
						})
					})
				})
			})
		})
	end
}

local v3 = {
	Default = function(text, layoutOrder, p)
		return Create("ImageButton")({
			Name = text .. "Button",
			BackgroundTransparency = 1,
			ImageColor3 = p and Constants.COLORS.WHITE or Constants.COLORS.PUMICE,
			AnchorPoint = Vector2.new(0.5, 0.5),
			Size = UDim2.new(1, 0, 1, 0),
			Image = p and Constants.PRIMARY_BUTTON_TEXTURE or Constants.SECONDARY_BUTTON_TEXTURE,
			ScaleType = Enum.ScaleType.Slice,
			SliceCenter = Rect.new(8, 8, 9, 9),
			LayoutOrder = layoutOrder,
			ZIndex = 8,
			Create("TextLabel")({
				Name = "ButtonText",
				Text = text,
				Size = UDim2.new(1, 0, 1, 0),
				TextColor3 = p and Constants.COLORS.SLATE or Constants.COLORS.PUMICE,
				BackgroundTransparency = 1,
				TextXAlignment = Enum.TextXAlignment.Center,
				TextYAlignment = Enum.TextYAlignment.Center,
				Font = Enum.Font.SourceSans,
				TextSize = 20,
				ZIndex = 8
			})
		})
	end
}

local ErrorPrompt = {}
ErrorPrompt.__index = ErrorPrompt

function ErrorPrompt.new(p, data)
	local object = setmetatable({}, ErrorPrompt)
	object._frame = p and v2[p]() or v2.Default()

	object._isOpen = false
	object._openAnimation = TweenService:Create(object._frame.PromptScale, tweenInfo, { Scale = 1 })
	object._closeAnimation = TweenService:Create(object._frame.PromptScale, tweenInfo, { Scale = 0 })

	object._buttonCount = 0
	object._playAnimation = true
	object._hideErrorCode = false
	object._menuIsOpenKey = "ErrorPrompt"

	if data then
		if data.PlayAnimation ~= nil then
			object._playAnimation = data.PlayAnimation
		end

		if data.HideErrorCode ~= nil then
			object._hideErrorCode = data.HideErrorCode
		end

		if data.MenuIsOpenKey ~= nil then
			object._menuIsOpenKey = data.MenuIsOpenKey
		end

		object._frame.MessageArea.ErrorFrame.ErrorMessage.TextScaled = data.MessageTextScaled or false
	end

	if not VRService.VREnabled and UserInputService.GamepadEnabled then
		GuiService:GetPropertyChangedSignal("SelectedCoreObject"):Connect(function()
			if object._isOpen and GuiService.SelectedCoreObject == nil then
				GuiService:Select(object._frame.MessageArea.ErrorFrame.ButtonArea)
			end
		end)
	end

	return object
end

local function sinkInput(_, _, _)
	return Enum.ContextActionResult.Sink
end

function ErrorPrompt:_open(p, p2, p3)
	self:setErrorText(p, p2, p3)
	self:_resizeHeight(RobloxGui.AbsoluteSize.Y)

	if not self._isOpen then
		MouseIconOverrideService.push("ErrorPromptOverride", Enum.OverrideMouseIconBehavior.ForceShow)
		GuiService:SetMenuIsOpen(true, self._menuIsOpenKey)
		self._frame.Visible = true
		self._isOpen = true

		if self._playAnimation then
			self._openAnimation:Play()
			self._openAnimation.Completed:wait()
		end

		self._frame.PromptScale.Scale = 1
	end

	if
		self._isOpen
		and (VRService.VREnabled or UserInputService.PreferredInput == Enum.PreferredInput.Gamepad or FFlagLuaSupportMicroGamepadPreferredInput and UserInputService.PreferredInput == Enum.PreferredInput.MicroGamepad)
	then
		GuiService:Select(self._frame.MessageArea.ErrorFrame.ButtonArea)
	end

	ContextActionService:BindCoreAction(
		"ErrorPromptAction",
		sinkInput,
		false,
		Enum.KeyCode.ButtonSelect,
		Enum.KeyCode.ButtonStart
	)
end

function ErrorPrompt:_close()
	if self._isOpen then
		MouseIconOverrideService.pop("ErrorPromptOverride")
		GuiService:SetMenuIsOpen(false, self._menuIsOpenKey)
		self._isOpen = false

		if self._playAnimation then
			self._closeAnimation:Play()
			self._closeAnimation.Completed:wait()
		else
			self._frame.PromptScale.Scale = 0
		end

		self._frame.Visible = false
		ContextActionService:UnbindCoreAction("ErrorPromptAction")
	end
end

function ErrorPrompt:setParent(parent)
	self._frame.Parent = parent
end

function ErrorPrompt:setErrorText(text, p, p2)
	local errorMessage = self._frame.MessageArea.ErrorFrame.ErrorMessage
	local robloxClientChannel = RunService:GetRobloxClientChannel()

	if self._hideErrorCode then
		errorMessage.Text = text
	elseif fFlag then
		local v4 = not p and -1 or p.Value

		local formatted = ("Error Code: %d"):format(v4)

		formatted = attemptTranslate("InGame.ConnectionError.Message.ErrorCode", formatted, { -- inferred equivalent call
			ERROR_CODE = tostring(v4)
		})
		local v5

		if GetFFlagDisplayChannelNameOnErrorPrompt() and p2 and robloxClientChannel then
			v5 = ("%s\n(%s, %s)"):format(
				text,
				formatted,
				v:Format("InGame.ConnectionError.Message.ChannelName", {
					CHANNEL_NAME = robloxClientChannel
				}) or ("Channel: %s"):format(robloxClientChannel)
			)
		end

		errorMessage.Text = v5 or ("%s\n(%s)"):format(text, formatted)
	elseif p then
		errorMessage.Text = ("%s\n(Error Code: %d)"):format(text, p.Value)
	else
		errorMessage.Text = ("%s\n(Error Code: -1)"):format(text)
	end
end

function ErrorPrompt:setErrorTitle(text, p)
	if not text then
		return
	end

	local errorTitle = self._frame.TitleFrame.ErrorTitle

	if not p then
		errorTitle.Text = text

		return
	end

	text = attemptTranslate(p, text) -- inferred equivalent call
	errorTitle.Text = text
end

function ErrorPrompt:onErrorChanged(p, p2, p3)
	if p == "" then
		self:_close()
	elseif p ~= "" then
		self:_open(p, p2, p3)
	end
end

function ErrorPrompt:_relayout()
	local buttonArea = self._frame.MessageArea.ErrorFrame.ButtonArea

	if self._buttonCount == 0 then
		buttonArea.Visible = false
		return
	end

	local v4 = (self._frame.Size.X.Offset - (self._buttonCount - 1) * Constants.BUTTON_CELL_PADDING - 2 * Constants.SIDE_PADDING) / self._buttonCount
	buttonArea.Visible = true
	buttonArea.ButtonLayout.CellSize = UDim2.new(0, v4, 0, Constants.BUTTON_HEIGHT)
end

function ErrorPrompt:clearButtons()
	local buttonArea = self._frame.MessageArea.ErrorFrame.ButtonArea

	if self._primaryShimmer then
		self._primaryShimmer = nil
	end

	local children = buttonArea:GetChildren()

	for _, child in pairs(children) do
		if child.name ~= "ButtonLayout" then
			child:Destroy()
		end
	end
end

function ErrorPrompt:updateButtons(options, value)
	self:clearButtons()

	local buttonArea = self._frame.MessageArea.ErrorFrame.ButtonArea
	local v4 = value or "Default"
	local count = 0

	for _, v5 in pairs(options or {}) do
		local text = v5.Text

		if v5.LocalizationKey then
			local localizationKey = v5.LocalizationKey
			text = v5.Text
			text = attemptTranslate(localizationKey, text) -- inferred equivalent call
		end

		local v6 = v3[v4](text, v5.LayoutOrder, v5.Primary)

		if v5.Primary then
			self._primaryShimmer = Shimmer.new(v6, "PrimaryButton")
		end

		v6.Parent = buttonArea
		v6.Activated:connect(v5.Callback)
		count += 1
	end

	if self._buttonCount ~= count then
		self._buttonCount = count
		self:_relayout()
	end
end

function ErrorPrompt:primaryShimmerPlay()
	if self._primaryShimmer then
		self._primaryShimmer:play()
	end
end

function ErrorPrompt:primaryShimmerStop()
	if self._primaryShimmer then
		self._primaryShimmer:stop()
	end
end

function ErrorPrompt:resizeWidthAndHeight(p, p2)
	self:_resizeWidth(p)
	self:_resizeHeight(p2)
	self:_relayout()
end

function ErrorPrompt:_resizeWidth(p)
	local offset = self._frame.Size.X.Offset
	local v4 = p - 2 * Constants.SIDE_MARGIN

	if Constants.ERROR_PROMPT_MAX_WIDTH.Default < v4 then
		if offset == Constants.ERROR_PROMPT_MAX_WIDTH.Default then
			return
		end

		v4 = Constants.ERROR_PROMPT_MAX_WIDTH.Default
	end

	if v4 < Constants.ERROR_PROMPT_MIN_WIDTH.Default then
		if offset == Constants.ERROR_PROMPT_MIN_WIDTH.Default then
			return
		end

		v4 = Constants.ERROR_PROMPT_MIN_WIDTH.Default
	end

	self._frame.Size = UDim2.new(0, v4, 0, self._frame.Size.Y.Offset)
end

function ErrorPrompt:_resizeHeight(p)
	local errorMessage = self._frame.MessageArea.ErrorFrame.ErrorMessage
	local vector2 = Vector2.new(self._frame.Size.X.Offset - 2 * Constants.SIDE_PADDING, 1000)
	local textSize = TextService:GetTextSize(errorMessage.Text, errorMessage.TextSize, errorMessage.Font, vector2)

	local v4 = math.max(
		math.min(
			Constants.ERROR_TITLE_FRAME_HEIGHT.Default + textSize.Y + Constants.SPLIT_LINE_THICKNESS + Constants.BUTTON_HEIGHT + Constants.LAYOUT_PADDING + 2 * Constants.SIDE_PADDING + 1,
			p - 2 * Constants.VERTICAL_MARGIN
		),
		Constants.ERROR_PROMPT_MIN_HEIGHT.Default
	)

	self._frame.Size = UDim2.new(0, self._frame.Size.X.Offset, 0, v4)
end

return ErrorPrompt
