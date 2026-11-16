local module = require("@luauforge/bundled/foJ")
local module2 = require("@luauforge/bundled/fpd")
local module3 = require("@luauforge/bundled/fpe")
local module4 = require("@luauforge/bundled/fpf")
local module5 = require("@luauforge/bundled/foM")
local sduiFeatureEntryPoint = module5.SduiFeatureEntryPoint
local useUiStatus = module5.useUiStatus
local getSduiApiStore = module5.getSduiApiStore

local module6 = require("@luauforge/bundled/fpg")
local module7 = require("@luauforge/bundled/fph")
local module8 = require("@luauforge/bundled/fpi")

local useTokens = module2.Hooks.useTokens

local function getDisplayedPrefix(p2, p3, p4, p5)
	if p3 == "" then
		return ""
	end

	if p2 == "" or p4 == "Error" or p4 == "Resolved" and not p5 then
		return p3
	end

	return p2
end

local function SduiSearchAutocomplete(props, callback)
	local v5 = useTokens()
	local state, setState = module.useState(nil)
	local state2, setState2 = module.useState(nil)
	local state3, setState3 = module.useState(0)
	local ref = module.useRef(nil)
	local v6 = module6(props.prefix)
	local v7 = useUiStatus(v6)

	local v8 = module.useCallback(function(p2)
		local data, v9 = getSduiApiStore().getData(v6)
		data.data(p2)
		data.status(p2)
		return v9
	end, { v6 })

	module3.useSignalState(v8)
	local data, v9 = getSduiApiStore().getData(v6)
	local ref2 = module.useRef("")

	local v10 = ref2.current
	local prefix = props.prefix

	if prefix == "" then
		v10 = ""
	elseif v10 == "" or v7 == "Error" or v7 == "Resolved" and not v9 then
		v10 = prefix
	end

	ref2.current = v10

	local current = ref2.current

	module.useEffect(function()
		if state == nil then
			return
		end

		local v11 = {}
		local v12 = nil
		local nextSelectionUp = nil
		local flag = false
		local v13 = false

		local function unlinkRow()
			if v12 then
				v12.NextSelectionUp = nextSelectionUp
				v12 = nil
				nextSelectionUp = nil
			end
		end
		local function updateFocusable()
			flag = false
			local v14 = module7(state)

			if v12 ~= v14 then
				if v12 then
					v12.NextSelectionUp = nextSelectionUp
					v12 = nil
					nextSelectionUp = nil
				end

				if v14 then
					v12 = v14
					nextSelectionUp = v14.NextSelectionUp
				end
			end

			if v14 then
				local v15 = if props.nextSelectionUp then props.nextSelectionUp.current else nil
				v14.NextSelectionUp = v15
			end

			ref.current = v14

			if typeof(callback) == "function" then
				callback(v14)
			elseif typeof(callback) == "table" then
				callback.current = v14
			end
		end
		local function requestUpdate()
			if flag then
				return
			end

			flag = true
			task.defer(function()
				if not v13 and flag then
					updateFocusable()
				end
			end)
		end
		local function trackRow(guiObject)
			if guiObject:IsA("GuiObject") and not v11[guiObject] then
				v11[guiObject] = {
					guiObject.AncestryChanged:Connect(requestUpdate),
					guiObject:GetPropertyChangedSignal("Selectable"):Connect(requestUpdate),
					guiObject:GetPropertyChangedSignal("Visible"):Connect(requestUpdate),
					guiObject:GetPropertyChangedSignal("AbsolutePosition"):Connect(requestUpdate)
				}
			end
		end
		local function untrackRow(p2)
			local v14 = v11[p2]

			if v14 then
				for k, connection in v14 do
					connection:Disconnect()
				end

				v11[p2] = nil
			end
		end
		local function updateContentHeight()
			setState3(state.AbsoluteSize.Y)
		end

		for i, descendant in state:GetDescendants() do
			trackRow(descendant)
		end

		updateFocusable()
		setState3(state.AbsoluteSize.Y)

		local descendantAddedConnection = state.DescendantAdded:Connect(function(descendant)
			trackRow(descendant)

			if flag then
				return
			end

			flag = true
			task.defer(function()
				if not v13 and flag then
					updateFocusable()
				end
			end)
		end)
		local descendantRemovingConnection = state.DescendantRemoving:Connect(function(descendant)
			local v14 = v11[descendant]

			if v14 then
				for k, connection in v14 do
					connection:Disconnect()
				end

				v11[descendant] = nil
			end

			if flag then
				return
			end

			flag = true
			task.defer(function()
				if not v13 and flag then
					updateFocusable()
				end
			end)
		end)
		local absoluteSizeChangedConnection = state:GetPropertyChangedSignal("AbsoluteSize"):Connect(updateContentHeight)
		return function()
			v13 = true
			descendantAddedConnection:Disconnect()
			descendantRemovingConnection:Disconnect()
			absoluteSizeChangedConnection:Disconnect()

			for k in v11 do
				local v14 = v11[k]

				if not v14 then
					continue
				end

				for k2, connection in v14 do
					connection:Disconnect()
				end

				v11[k] = nil
			end

			if v12 then
				v12.NextSelectionUp = nextSelectionUp
				v12 = nil
				nextSelectionUp = nil
			end

			ref.current = nil

			if typeof(callback) == "function" then
				callback(nil)
			elseif typeof(callback) == "table" then
				callback.current = nil
			end
		end
	end, { state, callback, props.nextSelectionUp })

	module.useEffect(function()
		if state2 == nil or props.onAbsoluteSizeChange == nil then
			return
		end

		local function reportSize()
			props.onAbsoluteSizeChange(state2)
		end

		props.onAbsoluteSizeChange(state2)

		local absoluteSizeChangedConnection = state2:GetPropertyChangedSignal("AbsoluteSize"):Connect(reportSize)
		return function()
			absoluteSizeChangedConnection:Disconnect()
		end
	end, { state2, props.onAbsoluteSizeChange })

	if props.prefix == "" then
		return nil
	end

	local v11 = not (state3 > 0) and 0 or v5.Padding.XSmall
	local v12 = state3 + v11
	local v13 = math.max(0, (math.min(v12, props.maxHeight or v12)))
	local createElement = module.createElement
	local frame = module4.Focusable.Frame
	local v14 = {
		LayoutOrder = props.LayoutOrder,
		Size = 0,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		SelectionGroup = true,
		SelectionBehaviorDown = 0,
		defaultChild = 0,
		inputBindings = 0,
		ref = 0
	}
	local v15 = if props.Size then UDim2.new(props.Size.X.Scale, props.Size.X.Offset, 0, v13) else UDim2.new(1, 0, 0, v13)
	v14.Size = v15

	v14.SelectionBehaviorDown = Enum.SelectionBehavior.Stop
	v14.defaultChild = ref
	v14.inputBindings = props.onCancel
		and {
			CancelSearch = module4.Input.onBegin(Enum.KeyCode.ButtonB, props.onCancel)
		}
		or nil

	v14.ref = setState2
	return createElement(frame, v14, {
		Scroll = module.createElement("ScrollingFrame", {
			Size = UDim2.fromScale(1, 1),
			CanvasSize = UDim2.fromOffset(0, v12),
			ScrollBarThickness = 0,
			ScrollingDirection = Enum.ScrollingDirection.Y,
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Selectable = false,
			ClipsDescendants = true
		}, {
			Content = module.createElement(sduiFeatureEntryPoint, {
				appPage = module8,
				configKey = module6(current),
				shouldDisplayLoading = false,
				shouldDisplayError = false,
				Position = UDim2.fromOffset(0, v11),
				Size = UDim2.new(1, 0, 0, 0),
				AutomaticSize = Enum.AutomaticSize.Y,
				additionalAnalyticsData = { prefix = current },
				ref = setState
			})
		})
	})
end

return module.memo(module.forwardRef(SduiSearchAutocomplete))
