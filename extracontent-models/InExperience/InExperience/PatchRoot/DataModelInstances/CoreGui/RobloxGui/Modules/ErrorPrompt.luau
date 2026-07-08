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
local Create = require(CorePackages.Workspace.Packages.AppCommonLib).Create
local MouseIconOverrideService = require(CorePackages.Workspace.Packages.CoreScriptsCommon).MouseIconOverrideService
local Constants = require(CorePackages.Workspace.Packages.CoreScriptsCommon).Constants
local Shimmer = require(RobloxGui.Modules.Shimmer)
local GetFFlagDisplayChannelNameOnErrorPrompt = require(RobloxGui.Modules.Flags.GetFFlagDisplayChannelNameOnErrorPrompt)
local Localization = require(CorePackages.Workspace.Packages.InExperienceLocales).Localization
local FFlag = settings():GetFFlag("LocalizeErrorCodeString")
local tweenInfo = TweenInfo.new(0.15, Enum.EasingStyle.Quint, Enum.EasingDirection.InOut, 0, false, 0)
local v20 = Localization.new(LocalizationService.RobloxLocaleId)

local function attemptTranslate(p1, p2, p3) -- line: 34
	-- upvalues: v20 (copy)
	local ok, result = pcall(function() -- line: 35
		-- upvalues: v20 (copy), p1 (copy), p3 (copy)
		return v20:Format(p1, p3)
	end)

	return ok and result or p2
end

local t1 = {
	Default = function() -- line: 43
		-- upvalues: Create (copy), Constants (copy)
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
			Create("UIScale")({
				Name = "PromptScale",
				Scale = 0
			}),
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
					TextSize = 25,
					BackgroundTransparency = 1,
					ZIndex = 8,
					TextColor3 = Constants.COLORS.WHITE,
					Size = UDim2.new(1, 0, 0, 28),
					Font = Enum.Font.SourceSansSemibold,
					TextXAlignment = Enum.TextXAlignment.Center,
					TextYAlignment = Enum.TextYAlignment.Center
				})
			}),
			Create("Frame")({
				Name = "SplitLine",
				LayoutOrder = 2,
				BorderSizePixel = 0,
				ZIndex = 8,
				Size = UDim2.new(1, -2 * Constants.SIDE_PADDING, 0, Constants.SPLIT_LINE_THICKNESS),
				BackgroundColor3 = Constants.COLORS.PUMICE
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
						TextSize = 20,
						ZIndex = 8,
						BackgroundTransparency = 1,
						TextWrapped = true,
						Size = UDim2.new(1, 0, 1, -Constants.BUTTON_HEIGHT - Constants.LAYOUT_PADDING),
						TextColor3 = Constants.COLORS.PUMICE,
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
local t2 = {
	Default = function(p4, p5, p6) -- line: 159
		-- upvalues: Create (copy), Constants (copy)
		return Create("ImageButton")({
			Name = p4 .. "Button",
			BackgroundTransparency = 1,
			ImageColor3 = p6 and Constants.COLORS.WHITE or Constants.COLORS.PUMICE,
			AnchorPoint = Vector2.new(0.5, 0.5),
			Size = UDim2.new(1, 0, 1, 0),
			Image = p6 and Constants.PRIMARY_BUTTON_TEXTURE or Constants.SECONDARY_BUTTON_TEXTURE,
			ScaleType = Enum.ScaleType.Slice,
			SliceCenter = Rect.new(8, 8, 9, 9),
			LayoutOrder = p5,
			ZIndex = 8,
			Create("TextLabel")({
				Name = "ButtonText",
				BackgroundTransparency = 1,
				TextSize = 20,
				ZIndex = 8,
				Text = p4,
				Size = UDim2.new(1, 0, 1, 0),
				TextColor3 = p6 and Constants.COLORS.SLATE or Constants.COLORS.PUMICE,
				TextXAlignment = Enum.TextXAlignment.Center,
				TextYAlignment = Enum.TextYAlignment.Center,
				Font = Enum.Font.SourceSans
			})
		})
	end
}
local t3 = {}

t3.__index = t3

function t3.new(p7, p8) -- line: 197
	-- upvalues: t3 (copy), t1 (copy), TweenService (copy), tweenInfo (copy), VRService (copy), UserInputService (copy), GuiService (copy)
	local self = setmetatable({}, t3)

	self._frame = p7 and t1[p7]() or t1.Default()
	self._isOpen = false
	self._openAnimation = TweenService:Create(self._frame.PromptScale, tweenInfo, {
		Scale = 1
	})
	self._closeAnimation = TweenService:Create(self._frame.PromptScale, tweenInfo, {
		Scale = 0
	})
	self._buttonCount = 0
	self._playAnimation = true
	self._hideErrorCode = false
	self._menuIsOpenKey = "ErrorPrompt"

	if p8 then
		if p8.PlayAnimation ~= nil then
			self._playAnimation = p8.PlayAnimation
		end

		if p8.HideErrorCode ~= nil then
			self._hideErrorCode = p8.HideErrorCode
		end

		if p8.MenuIsOpenKey ~= nil then
			self._menuIsOpenKey = p8.MenuIsOpenKey
		end

		self._frame.MessageArea.ErrorFrame.ErrorMessage.TextScaled = p8.MessageTextScaled or false
	end

	if not VRService.VREnabled and UserInputService.GamepadEnabled then
		GuiService:GetPropertyChangedSignal("SelectedCoreObject"):Connect(function() -- line: 230
			-- upvalues: self (copy), GuiService (copy)
			if self._isOpen and GuiService.SelectedCoreObject == nil then
				GuiService:Select(self._frame.MessageArea.ErrorFrame.ButtonArea)
			end
		end)
	end

	return self
end

local function sinkInput(_, _, _) -- line: 240
	return Enum.ContextActionResult.Sink
end

function t3._open(p12, p13, p14, p15) -- line: 244
	-- upvalues: RobloxGui (copy), MouseIconOverrideService (copy), GuiService (copy), VRService (copy), UserInputService (copy), ContextActionService (copy), sinkInput (copy)
	p12:setErrorText(p13, p14, p15)
	p12:_resizeHeight(RobloxGui.AbsoluteSize.Y)

	if not p12._isOpen then
		MouseIconOverrideService.push("ErrorPromptOverride", Enum.OverrideMouseIconBehavior.ForceShow)
		GuiService:SetMenuIsOpen(true, p12._menuIsOpenKey)
		p12._frame.Visible = true
		p12._isOpen = true

		if p12._playAnimation then
			p12._openAnimation:Play()
			p12._openAnimation.Completed:wait()
			p12._frame.PromptScale.Scale = 1
		else
			p12._frame.PromptScale.Scale = 1
		end
	end

	if p12._isOpen and (VRService.VREnabled or UserInputService.PreferredInput == Enum.PreferredInput.Gamepad) then
		GuiService:Select(p12._frame.MessageArea.ErrorFrame.ButtonArea)
	end

	ContextActionService:BindCoreAction("ErrorPromptAction", sinkInput, false, Enum.KeyCode.ButtonSelect, Enum.KeyCode.ButtonStart)
end
function t3._close(p16) -- line: 266
	-- upvalues: MouseIconOverrideService (copy), GuiService (copy), ContextActionService (copy)
	if p16._isOpen then
		MouseIconOverrideService.pop("ErrorPromptOverride")
		GuiService:SetMenuIsOpen(false, p16._menuIsOpenKey)
		p16._isOpen = false

		if p16._playAnimation then
			p16._closeAnimation:Play()
			p16._closeAnimation.Completed:wait()
		else
			p16._frame.PromptScale.Scale = 0
		end

		p16._frame.Visible = false
		ContextActionService:UnbindCoreAction("ErrorPromptAction")
	end
end
function t3.setParent(p17, p18) -- line: 282
	p17._frame.Parent = p18
end
function t3.setErrorText(p19, p20, p21, p22) -- line: 286
	-- upvalues: RunService (copy), FFlag (copy), v20 (copy), GetFFlagDisplayChannelNameOnErrorPrompt (copy)
	local ErrorMessage = p19._frame.MessageArea.ErrorFrame.ErrorMessage
	local RobloxClientChannel = RunService:GetRobloxClientChannel()

	if p19._hideErrorCode then
		ErrorMessage.Text = p20

		return
	end

	if FFlag then
		local n1 = -1

		if p21 then
			n1 = p21.Value
		end

		local v54 = ("Error Code: %d"):format(n1)
		local t4 = {
			ERROR_CODE = tostring(n1)
		}
		local s1 = "InGame.ConnectionError.Message.ErrorCode"
		local ok, result = pcall(function() -- line: 35
			-- upvalues: v20 (copy), s1 (copy), t4 (copy)
			return v20:Format(s1, t4)
		end)
		local v59 = ok and result or v54
		local v60 = nil

		if GetFFlagDisplayChannelNameOnErrorPrompt() and p22 and RobloxClientChannel then
			v60 = ("%s\n(%s, %s)"):format(p20, v59, v20:Format("InGame.ConnectionError.Message.ChannelName", {
				CHANNEL_NAME = RobloxClientChannel
			}) or ("Channel: %s"):format(RobloxClientChannel))
		end

		if not v60 then
			v60 = ("%s\n(%s)"):format(p20, v59)
		end

		ErrorMessage.Text = v60

		return
	end

	if not p21 then
		ErrorMessage.Text = ("%s\n(Error Code: -1)"):format(p20)

		return
	end

	ErrorMessage.Text = ("%s\n(Error Code: %d)"):format(p20, p21.Value)
end
function t3.setErrorTitle(p23, p24, p25) -- line: 325
	-- upvalues: v20 (copy)
	if not p24 then
		return
	end

	local ErrorTitle = p23._frame.TitleFrame.ErrorTitle

	if p25 then
		local v65 = nil
		local ok, result = pcall(function() -- line: 35
			-- upvalues: v20 (copy), p25 (copy), v65 (copy)
			return v20:Format(p25, v65)
		end)

		ErrorTitle.Text = ok and result or p24

		return
	end

	ErrorTitle.Text = p24
end
function t3.onErrorChanged(p26, p27, p28, p29) -- line: 337
	if p27 == "" then
		p26:_close()

		return
	end

	if p27 ~= "" then
		p26:_open(p27, p28, p29)
	end
end
function t3._relayout(p30) -- line: 346
	-- upvalues: Constants (copy)
	local ButtonArea = p30._frame.MessageArea.ErrorFrame.ButtonArea

	if p30._buttonCount == 0 then
		ButtonArea.Visible = false

		return
	end

	local v74 = (p30._frame.Size.X.Offset - (p30._buttonCount - 1) * Constants.BUTTON_CELL_PADDING - 2 * Constants.SIDE_PADDING) / p30._buttonCount

	ButtonArea.Visible = true
	ButtonArea.ButtonLayout.CellSize = UDim2.new(0, v74, 0, Constants.BUTTON_HEIGHT)
end
function t3.clearButtons(p31) -- line: 358
	local ButtonArea = p31._frame.MessageArea.ErrorFrame.ButtonArea

	if p31._primaryShimmer then
		p31._primaryShimmer = nil
	end

	local children = ButtonArea:GetChildren()

	for _, v in pairs(children) do
		if v.name ~= "ButtonLayout" then
			v:Destroy()
		end
	end
end
function t3.updateButtons(p32, p33, p34) -- line: 391
	-- upvalues: v20 (copy), t2 (copy), Shimmer (copy)
	if not p33 then
		p33 = {}
	end

	if not p34 then
		p34 = "Default"
	end

	p32:clearButtons()

	local ButtonArea = p32._frame.MessageArea.ErrorFrame.ButtonArea
	local n2 = 0

	for _, v in pairs(p33) do
		local vText = v.Text

		if v.LocalizationKey then
			local LocalizationKey = v.LocalizationKey
			local vText2 = v.Text
			local v90 = nil
			local ok, result = pcall(function() -- line: 35
				-- upvalues: v20 (copy), LocalizationKey (copy), v90 (copy)
				return v20:Format(LocalizationKey, v90)
			end)

			vText = ok and result or vText2
		end

		local v93 = t2[p34](vText, v.LayoutOrder, v.Primary)

		if v.Primary then
			p32._primaryShimmer = Shimmer.new(v93, "PrimaryButton")
		end

		v93.Parent = ButtonArea
		v93.Activated:connect(v.Callback)
		n2 += 1
	end

	if n2 ~= p32._buttonCount then
		p32._buttonCount = n2
		p32:_relayout()
	end
end
function t3.primaryShimmerPlay(p35) -- line: 425
	if p35._primaryShimmer then
		p35._primaryShimmer:play()
	end
end
function t3.primaryShimmerStop(p36) -- line: 431
	if p36._primaryShimmer then
		p36._primaryShimmer:stop()
	end
end
function t3.resizeWidthAndHeight(p37, p38, p39) -- line: 437
	p37:_resizeWidth(p38)
	p37:_resizeHeight(p39)
	p37:_relayout()
end
function t3._resizeWidth(p40, p41) -- line: 443
	-- upvalues: Constants (copy)
	local XOffset = p40._frame.Size.X.Offset
	local v102 = p41 - 2 * Constants.SIDE_MARGIN

	if v102 > Constants.ERROR_PROMPT_MAX_WIDTH.Default then
		if XOffset == Constants.ERROR_PROMPT_MAX_WIDTH.Default then
			return
		end

		v102 = Constants.ERROR_PROMPT_MAX_WIDTH.Default
	end

	if v102 < Constants.ERROR_PROMPT_MIN_WIDTH.Default then
		if XOffset == Constants.ERROR_PROMPT_MIN_WIDTH.Default then
			return
		end

		v102 = Constants.ERROR_PROMPT_MIN_WIDTH.Default
	end

	p40._frame.Size = UDim2.new(0, v102, 0, p40._frame.Size.Y.Offset)
end
function t3._resizeHeight(p42, p43) -- line: 466
	-- upvalues: Constants (copy), TextService (copy)
	local ErrorMessage = p42._frame.MessageArea.ErrorFrame.ErrorMessage
	local vector2 = Vector2.new(p42._frame.Size.X.Offset - 2 * Constants.SIDE_PADDING, 1000)
	local TextSize = TextService:GetTextSize(ErrorMessage.Text, ErrorMessage.TextSize, ErrorMessage.Font, vector2)
	local v108 = math.max(math.min(Constants.ERROR_TITLE_FRAME_HEIGHT.Default + TextSize.Y + Constants.SPLIT_LINE_THICKNESS + Constants.BUTTON_HEIGHT + Constants.LAYOUT_PADDING + 2 * Constants.SIDE_PADDING + 1, p43 - 2 * Constants.VERTICAL_MARGIN), Constants.ERROR_PROMPT_MIN_HEIGHT.Default)

	p42._frame.Size = UDim2.new(0, p42._frame.Size.X.Offset, 0, v108)
end

return t3
