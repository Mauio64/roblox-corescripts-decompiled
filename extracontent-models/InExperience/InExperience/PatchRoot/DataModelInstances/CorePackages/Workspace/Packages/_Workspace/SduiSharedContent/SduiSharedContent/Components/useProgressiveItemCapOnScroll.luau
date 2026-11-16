local SduiSharedContent = script:FindFirstAncestor("SduiSharedContent")
local parent = SduiSharedContent.Parent
local React = require(parent.React)

local FFlagSduiProgressiveScrollMathFix = require(SduiSharedContent.Flags.FFlagSduiProgressiveScrollMathFix)

local function itemCountForRowCap(current, p: number) -- 3 equivalent calls inferred from this helper
	if p <= 0 then
		return 0
	end

	local total = 0

	for k, item in current do
		total += not (item > 0) and 1 or item

		if p <= total then
			return k
		end
	end

	return #current
end

local function rowCountsEqual(current, current2): boolean -- 1 equivalent call inferred from this helper
	if current == current2 then
		return true
	end

	if #current ~= #current2 then
		return false
	end

	for i = 1, #current do
		if current[i] ~= current2[i] then
			return false
		end
	end

	return true
end

local function useProgressiveItemCapOnScroll(current, p: number, p2: number, p3, p4, p5: number, p6: number)
	local v = math.max(0, p)
	local v2 = math.max(1, p2)
	local total = 0

	for _, v3 in current do
		total += not (v3 > 0) and 1 or v3
	end

	local count = #current

	local state, setState = React.useState(v)
	local ref

	if FFlagSduiProgressiveScrollMathFix then
		ref = React.useRef(0)
	else
		ref = nil
	end

	local ref2

	if FFlagSduiProgressiveScrollMathFix then
		ref2 = React.useRef(false)
	else
		ref2 = nil
	end

	local ref3

	if FFlagSduiProgressiveScrollMathFix then
		ref3 = React.useRef(current)
	else
		ref3 = nil
	end

	local current5 = itemCountForRowCap(current, math.min(state, total)) -- inferred equivalent call

	if FFlagSduiProgressiveScrollMathFix and count > 0 then
		if count < ref.current then
			ref.current = count
		end

		if current5 < ref.current then
			current5 = ref.current
		else
			ref.current = current5
		end
	end

	local selected = current5 < count

	local ref4 = React.useRef(nil)

	local ref5 = React.useRef(nil)

	React.useEffect(function()
		local v3 = nil

		if FFlagSduiProgressiveScrollMathFix and not rowCountsEqual(ref3.current, current) then -- inferred equivalent call
			ref3.current = current

			if ref4.current ~= nil then
				ref4.current = nil
				ref5.current = nil
				v3 = true
			end
		end

		local current2

		if p3 then
			current2 = p3.current
		else
			current2 = nil
		end

		if not selected or current2 == nil then
			return nil
		end

		local flag = false

		local function readContentHeight() -- 5 equivalent calls inferred from this helper
			local current3

			if p4 then
				current3 = p4.current
			end

			if current3 == nil then
				return nil
			end

			return current3.AbsoluteContentSize.Y
		end

		local y, y2, y3

		if FFlagSduiProgressiveScrollMathFix then
			y = current2.AbsoluteCanvasSize.Y
			y2 = current2.AbsoluteWindowSize.Y
			local current3

			if p4 then
				current3 = p4.current
			end

			if current3 == nil then
				y3 = nil
			else
				y3 = current3.AbsoluteContentSize.Y
			end
		else
			y3 = nil
			y = nil
			y2 = nil
		end

		local function showNextBatch() -- 4 equivalent calls inferred from this helper
			local current4

			if FFlagSduiProgressiveScrollMathFix then
				current4 = y3 or y
			else
				current4 = readContentHeight() or current2.AbsoluteCanvasSize.Y -- inferred equivalent call
			end

			ref5.current = current4
			local current3

			if FFlagSduiProgressiveScrollMathFix then
				current3 = ref.current
			else
				current3 = nil
			end

			setState(function(p7: number)
				if FFlagSduiProgressiveScrollMathFix then
					local v4 = itemCountForRowCap(current, math.min(p7, total)) -- inferred equivalent call

					local v5 = math.min(#current, (math.max(v4, current3)))

					local v6 = not (v4 < current3) and 1 or v2
					local total2 = 0

					for i = 1, v5 do
						local v7 = current[i]
						total2 += not (v7 > 0) and 1 or v7
					end

					return (math.max(p7 + v2, total2 + v6))
				else
					local v4 = itemCountForRowCap(current, math.min(p7, total)) -- inferred equivalent call
					local total2 = 0

					for i = 1, v4 do
						local v5 = current[i]
						total2 += not (v5 > 0) and 1 or v5
					end

					return (math.max(p7 + v2, total2 + 1))
				end
			end)
		end

		local function showNextBatchIfNearEnd()
			if flag then
				return
			end

			if FFlagSduiProgressiveScrollMathFix then
				ref2.current = true
			end

			local y4 = current2.CanvasPosition.Y
			local v4, v5, v6

			if FFlagSduiProgressiveScrollMathFix then
				v4 = y
				v5 = y2
				v6 = y3 or v4

				if v6 <= 0 then
					return
				end
			else
				v4 = current2.AbsoluteCanvasSize.Y
				v5 = current2.AbsoluteWindowSize.Y
				v6 = readContentHeight() or v4 -- inferred equivalent call
			end

			local current3 = ref5.current

			if current3 ~= nil and v6 == current3 or v4 - v5 - y4 > math.max(0, p5) then
				return
			end

			local current4 = ref4.current

			if current4 ~= nil and y4 <= current4 then
				return
			end

			if FFlagSduiProgressiveScrollMathFix then
				ref2.current = false
			end

			ref4.current = y4
			showNextBatch() -- inferred equivalent call
		end

		local function decideUnderfill()
			if flag then
				return
			end

			local current4

			if FFlagSduiProgressiveScrollMathFix then
				current4 = y3
			else
				current4 = readContentHeight() -- inferred equivalent call
			end

			if current4 == nil or current4 <= 0 then
				return
			end

			local v4

			if FFlagSduiProgressiveScrollMathFix then
				v4 = y2
			else
				v4 = current2.AbsoluteWindowSize.Y
			end

			if v4 <= current4 then
				return
			end

			local current3 = ref5.current

			if current3 ~= nil and current4 == current3 then
				return
			end

			ref5.current = current4
			showNextBatch() -- inferred equivalent call
		end

		local thread = nil
		local function scheduleUnderfillDecision() -- 3 equivalent calls inferred from this helper
			if thread then
				task.cancel(thread)
			end

			thread = task.delay(p6 / 1000, function()
				thread = nil

				if not flag then
					if flag then
						return
					end

					local current4

					if FFlagSduiProgressiveScrollMathFix then
						current4 = y3
					else
						current4 = readContentHeight() -- inferred equivalent call
					end

					if current4 ~= nil then
						if current4 <= 0 then
							return
						end

						local v4

						if FFlagSduiProgressiveScrollMathFix then
							v4 = y2
						else
							v4 = current2.AbsoluteWindowSize.Y
						end

						if v4 <= current4 then
							return
						end

						local current3 = ref5.current

						if current3 ~= nil and current4 == current3 then
							return
						end

						ref5.current = current4
						showNextBatch() -- inferred equivalent call
					end
				end
			end)
		end

		local connections

		if FFlagSduiProgressiveScrollMathFix then
			connections = {
				current2:GetPropertyChangedSignal("CanvasPosition"):Connect(showNextBatchIfNearEnd),
				current2:GetPropertyChangedSignal("AbsoluteCanvasSize"):Connect(function()
					y = current2.AbsoluteCanvasSize.Y

					if ref2.current then
						showNextBatchIfNearEnd()
					end

					scheduleUnderfillDecision() -- inferred equivalent call
				end),
				current2:GetPropertyChangedSignal("AbsoluteWindowSize"):Connect(function()
					y2 = current2.AbsoluteWindowSize.Y
					local current3 = ref4.current

					if current3 ~= nil and y - y2 < current3 then
						ref4.current = nil
						ref5.current = nil
						showNextBatchIfNearEnd()
					end

					scheduleUnderfillDecision() -- inferred equivalent call
				end)
			}

			local current3 = p4 and p4.current

			if current3 ~= nil then
				table.insert(connections, current3:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
					y3 = current3.AbsoluteContentSize.Y

					if ref2.current then
						showNextBatchIfNearEnd()
					end

					scheduleUnderfillDecision() -- inferred equivalent call
				end))
			end
		else
			connections = {
				current2:GetPropertyChangedSignal("CanvasPosition"):Connect(showNextBatchIfNearEnd),
				current2:GetPropertyChangedSignal("AbsoluteWindowSize"):Connect(scheduleUnderfillDecision)
			}

			if p4 ~= nil and p4.current ~= nil then
				table.insert(
					connections,
					p4.current:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(scheduleUnderfillDecision)
				)
			end
		end

		if thread then
			task.cancel(thread)
		end

		thread = task.delay(p6 / 1000, function()
			thread = nil

			if not flag then
				if flag then
					return
				end

				local current4

				if FFlagSduiProgressiveScrollMathFix then
					current4 = y3
				else
					current4 = readContentHeight() -- inferred equivalent call
				end

				if current4 ~= nil then
					if current4 <= 0 then
						return
					end

					local v4

					if FFlagSduiProgressiveScrollMathFix then
						v4 = y2
					else
						v4 = current2.AbsoluteWindowSize.Y
					end

					if v4 <= current4 then
						return
					end

					local current3 = ref5.current

					if current3 ~= nil and current4 == current3 then
						return
					end

					ref5.current = current4
					showNextBatch() -- inferred equivalent call
				end
			end
		end)

		if FFlagSduiProgressiveScrollMathFix and (v3 or ref2.current) then
			showNextBatchIfNearEnd()
		end

		return function()
			flag = true

			if thread then
				task.cancel(thread)
			end

			for _, connection in connections do
				connection:Disconnect()
			end
		end
	end, { selected, v2, total, p3, p4, p5, current, p6 })

	return current5, selected
end

return useProgressiveItemCapOnScroll
