local ParentParent = script.Parent.Parent.Parent
local ParentParentParent = ParentParent.Parent
local Foundation = require(ParentParentParent.Foundation)
local Localization = require(ParentParentParent.Localization)
local React = require(ParentParentParent.React)
local RoactUtils = require(ParentParentParent.RoactUtils)
local RobloxAppHooks = require(ParentParentParent.RobloxAppHooks)
local UIBlox = require(ParentParentParent.UIBlox)
local Icon = Foundation.Icon
local FoundationText = Foundation.Text
local View = Foundation.View
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local InteractiveAlert = UIBlox.App.Dialog.Alert.InteractiveAlert
local CapturePromptItem = require(ParentParent.Components.CaptureService.CapturePromptItem)
local useAnalytics = require(ParentParent.Analytics.useAnalytics)
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useEffectOnce = RoactUtils.Hooks.useEffectOnce
local useLocalization = Localization.Hooks.useLocalization
local usePinInputStateWhileOpen = require(ParentParent.Hooks.usePinInputStateWhileOpen)
local useScreenSize = RobloxAppHooks.useScreenSize
local EventNames = require(ParentParent.Analytics.EventNames)
local SaveCapturesPromptFinished = require(ParentParent.Thunks.SaveCapturesPromptFinished)

require(ParentParent.Types)

local FFlagCapturePermissionsPromptFreeMouse = require(ParentParent.Flags.FFlagCapturePermissionsPromptFreeMouse)

return function(t1: {[any]: any}) -- line: 69
	-- upvalues: useAnalytics (copy), useDispatch (copy), useScreenSize (copy), React (copy), useLocalization (copy), usePinInputStateWhileOpen (copy), FFlagCapturePermissionsPromptFreeMouse (copy), EventNames (copy), useEffectOnce (copy), SaveCapturesPromptFinished (copy), ButtonType (copy), View (copy), CapturePromptItem (copy), FoundationText (copy), Icon (copy), InteractiveAlert (copy)
	local v29 = useAnalytics()
	local v30 = useDispatch()
	local v31 = useScreenSize()
	local v32, v33 = React.useState(Vector2.new(0, 0))
	local v34, v35 = React.useState(Vector2.new(0, 0))
	local v36, v37 = React.useState(1)
	local v38, v39 = React.useState({})
	local contents = t1.promptData.contents
	local v41 = t1.enableInputDelayed == nil or t1.enableInputDelayed
	local g45 = nil
	local v44 = nil

	for _, v43 in contents do
		if typeof(v43) == "Content" and (v43.Object ~= nil and v43.Object:IsA("VideoCapture")) then
			v44 = true
			g45 = true
		end

		if g45 then
			break
		end
	end

	if not g45 then
		v44 = false
	end

	g45 = false

	local v46 = v44
	local v47 = useLocalization({
		bodyText = "Feature.Captures.Body.SaveCapturesPrompt",
		no = "Feature.Captures.Action.NoThanks",
		title = "Feature.Captures.Title.SaveCapturesPrompt",
		yes = "Feature.Captures.Action.Save"
	})

	usePinInputStateWhileOpen(FFlagCapturePermissionsPromptFreeMouse)
	React.useEffect(function() -- line: 93
		-- upvalues: v29 (copy), EventNames (copy)
		v29.fireEvent(EventNames.SaveCapturesPromptViewed)
	end, {})
	React.useEffect(function() -- line: 97
		-- upvalues: v46 (copy), v29 (copy), EventNames (copy)
		if v46 then
			v29.fireEvent(EventNames.SaveCapturesPromptVideoPrompted)
		end
	end, { v46 })
	useEffectOnce(function() -- line: 103
		-- upvalues: contents (copy), v39 (copy)
		local t2 = {}

		for v58, _ in contents do
			t2[v58] = true
		end

		v39(t2)
	end, { contents })

	local v48 = React.useCallback(function(b1: boolean) -- line: 111
		-- upvalues: v39 (copy), v36 (copy)
		v39(function(p1) -- line: 112
			-- upvalues: v36 (copy), b1 (copy)
			local v80 = table.clone(p1)

			v80[v36] = b1

			return v80
		end)
	end, { v36 })
	local v49 = React.useCallback(function(p2) -- line: 119
		-- upvalues: v33 (copy)
		v33(p2.AbsoluteSize)
	end, { v33 })
	local v50 = React.useCallback(function(p3) -- line: 123
		-- upvalues: v35 (copy)
		v35(p3.AbsoluteSize)
	end, { v35 })
	local v51 = React.useCallback(function() -- line: 127
		-- upvalues: v38 (copy), contents (copy), v29 (copy), EventNames (copy), v30 (copy), SaveCapturesPromptFinished (copy), t1 (copy)
		local n1 = 0
		local n2 = 0
		local v65 = false
		local t3 = {}

		for v67, v68 in v38 do
			t3[contents[v67]] = v68

			if v68 then
				n1 += 1

				local v69 = contents[v67]

				if typeof(v69) == "Content" and (v69.Object ~= nil and v69.Object:IsA("VideoCapture")) then
					v65 = true
				end
			end

			n2 += 1
		end

		if v65 then
			v29.fireEvent(EventNames.SaveCapturesPromptVideoAccepted)
		end

		v29.fireEvent(EventNames.SaveCapturesPromptAccepted, {
			savedCaptures = n1,
			totalCaptures = n2
		})
		v30(SaveCapturesPromptFinished(t1.promptId, t3))
	end, {
		t1.promptData,
		t1.promptId,
		v38
	})
	local v52 = React.useCallback(function() -- line: 156
		-- upvalues: t1 (copy), v29 (copy), EventNames (copy), v30 (copy), SaveCapturesPromptFinished (copy)
		local g73 = nil
		local v72 = nil

		for _, v71 in t1.promptData.contents do
			if typeof(v71) == "Content" and (v71.Object ~= nil and v71.Object:IsA("VideoCapture")) then
				v72 = true
				g73 = true
			end

			if g73 then
				break
			end
		end

		if not g73 then
			v72 = false
		end

		g73 = false

		if v72 then
			v29.fireEvent(EventNames.SaveCapturesPromptVideoRejected)
		end

		v29.fireEvent(EventNames.SaveCapturesPromptRejected)

		local t4 = {}

		for _, v76 in t1.promptData.contents do
			t4[v76] = false
		end

		v30(SaveCapturesPromptFinished(t1.promptId, t4))
	end, {
		t1.promptData,
		t1.promptId
	})
	local v53 = React.useCallback(function() -- line: 170
		-- upvalues: v37 (copy), v36 (copy)
		v37((math.max(1, v36 - 1)))
	end, { v36 })
	local v54 = React.useCallback(function() -- line: 174
		-- upvalues: v37 (copy), contents (copy), v36 (copy)
		v37((math.min(#contents, v36 + 1)))
	end, {
		contents,
		v36
	})
	local v55 = React.useMemo(function() -- line: 178
		-- upvalues: v52 (copy), v47 (copy), ButtonType (copy), v41 (copy), v51 (copy)
		return {
			buttons = {
				{
					isDefaultChild = true,
					props = {
						onActivated = v52,
						text = v47.no
					}
				},
				{
					isDefaultChild = false,
					buttonType = ButtonType.PrimarySystem,
					props = {
						delayInputSeconds = 2,
						enableInputDelayed = v41,
						isDelayedInput = v41,
						onActivated = v51,
						text = v47.yes
					}
				}
			}
		}
	end, {
		v47,
		v51,
		v52
	})
	local v56 = React.useCallback(function() -- line: 204
		-- upvalues: v32 (copy), v34 (copy), v31 (copy), React (copy), View (copy), v50 (copy), CapturePromptItem (copy), contents (copy), v36 (copy), v38 (copy), v48 (copy), FoundationText (copy), v53 (copy), Icon (copy), v54 (copy)
		local v77 = v32.Y - v34.Y
		local v78 = v31.Y - 80 - v77

		return React.createElement(View, {
			Size = UDim2.new(1, 0, 0, 200),
			sizeConstraint = {
				MaxSize = Vector2.new(1e999, v78)
			},
			onAbsoluteSizeChanged = v50
		}, {
			CapturePromptItem = React.createElement(CapturePromptItem, {
				content = contents[v36],
				isSelected = v38[v36],
				showCheckbox = #contents > 1,
				updateSelected = v48
			}),
			Overlay = React.createElement(View, {
				LayoutOrder = 2,
				tag = "padding-small size-full",
				ZIndex = 2
			}, {
				CountView = React.createElement(View, {
					tag = "bg-over-media-0 anchor-top-left auto-xy clip padding-x-small padding-y-xsmall position-top-left radius-circle",
					Visible = #contents > 1
				}, {
					Count = React.createElement(FoundationText, {
						tag = "auto-xy content-emphasis text-body-small",
						Text = `{ v36 }/{ #contents }`
					})
				}),
				PrevCaptureButton = if not (v36 > 1) then nil else React.createElement(View, {
					tag = "bg-over-media-0 anchor-center-left auto-xy clip position-center-left radius-circle",
					onActivated = v53
				}, {
					CycleLeftIcon = React.createElement(Icon, {
						name = "icons/actions/cycleLeft"
					})
				}),
				NextCaptureButton = if not (v36 < #contents) then nil else React.createElement(View, {
					tag = "bg-over-media-0 anchor-center-right auto-xy clip position-center-right radius-circle",
					onActivated = v54
				}, {}, {
					CycleRightIcon = React.createElement(Icon, {
						name = "icons/actions/cycleRight"
					})
				})
			})
		})
	end, {
		v32,
		contents,
		v34,
		v36,
		v50,
		v54,
		v53,
		v31,
		v38,
		v48
	})

	return React.createElement(InteractiveAlert, {
		isMiddleContentFocusable = false,
		bodyText = v47.bodyText,
		buttonStackInfo = v55,
		middleContent = v56,
		onAbsoluteSizeChanged = v49,
		position = UDim2.fromScale(0.5, 0.5),
		screenSize = v31,
		title = v47.title
	})
end
