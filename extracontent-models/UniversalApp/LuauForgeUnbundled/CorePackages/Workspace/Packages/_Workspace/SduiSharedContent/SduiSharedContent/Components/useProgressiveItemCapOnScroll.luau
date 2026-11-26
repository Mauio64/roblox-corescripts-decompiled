local React = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/React")

local FFlagSduiProgressiveScrollMathFix = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/SduiSharedContent/Flags/FFlagSduiProgressiveScrollMathFix")

local function itemCountForRowCap(list, p2)
	if p2 <= 0 then
		return 0
	end

	local total = 0

	for k, item in list do
		total += not (item > 0) and 1 or item

		if p2 <= total then
			return k
		end
	end

	return #list
end

local function rowCountsEqual(list, list2): boolean
	if list == list2 then
		return true
	end

	if #list ~= #list2 then
		return false
	end

	for i = 1, #list do
		if list[i] ~= list2[i] then
			return false
		end
	end

	return true
end

local function useProgressiveItemCapOnScroll(current, p2, p3, p4, p5, p6, p7)
	local v5 = math.max(0, p2)
	local v6 = math.max(1, p3)
	local total = 0

	for k, v7 in current do
		total += not (v7 > 0) and 1 or v7
	end

	local count = #current

	local state, setState = React.useState(v5)
	local ref = if FFlagSduiProgressiveScrollMathFix then React.useRef(0) else nil
	local ref2 = if FFlagSduiProgressiveScrollMathFix then React.useRef(false) else nil

	local ref3 = if FFlagSduiProgressiveScrollMathFix then React.useRef(current) else nil

	local v7 = math.min(state, total)
	local v8

	if v7 <= 0 then
		v8 = 0
	else
		local total2 = 0
		local flag = true

		for k, v9 in current do
			total2 += not (v9 > 0) and 1 or v9

			if v7 <= total2 then
				v8 = k
				flag = false
				break
			end
		end

		if flag then
			v8 = #current
		end
	end

	if FFlagSduiProgressiveScrollMathFix and count > 0 then
		if count < ref.current then
			ref.current = count
		end

		if v8 < ref.current then
			v8 = ref.current
		else
			ref.current = v8
		end
	end

	local v9 = v8 < count

	local ref4 = React.useRef(nil)

	local ref5 = React.useRef(nil)

	React.useEffect(function()
		local v10 = nil

		if FFlagSduiProgressiveScrollMathFix then
			local current2 = ref3.current
			local v11 = current
			local v12

			if current2 == v11 then
				v12 = true
			elseif #current2 == #v11 then
				local flag = true

				for i = 1, #current2 do
					if current2[i] ~= v11[i] then
						v12 = false
						flag = false
						break
					end
				end

				if flag then
					v12 = true
				end
			else
				v12 = false
			end

			if not v12 then
				ref3.current = current

				if ref4.current ~= nil then
					ref4.current = nil
					ref5.current = nil
					v10 = true
				end
			end
		end

		local current2 = if p4 then p4.current else nil

		if not v9 or current2 == nil then
			return nil
		end

		local flag = false

		local function readContentHeight()
			local current3 = if p5 then p5.current else nil

			if current3 == nil then
				return nil
			end

			return current3.AbsoluteContentSize.Y
		end

		local y, y2, y3

		if FFlagSduiProgressiveScrollMathFix then
			y = current2.AbsoluteCanvasSize.Y
			y2 = current2.AbsoluteWindowSize.Y
			local current3 = if p5 then p5.current else nil
			y3 = if current3 ~= nil then current3.AbsoluteContentSize.Y else nil
		else
			y3 = nil
			y = nil
			y2 = nil
		end

		local function showNextBatch()
			local v11 = ref5
			local v12

			if FFlagSduiProgressiveScrollMathFix then
				v12 = y3 or y
			else
				local current3 = if p5 then p5.current else nil

				v12 = (if current3 ~= nil then current3.AbsoluteContentSize.Y else nil)
					or current2.AbsoluteCanvasSize.Y
			end

			v11.current = v12

			local current3 = if FFlagSduiProgressiveScrollMathFix then ref.current else nil

			setState(function(p8)
				if FFlagSduiProgressiveScrollMathFix then
					local v13 = current
					local v14 = math.min(p8, total)
					local v15

					if v14 <= 0 then
						v15 = 0
					else
						local total2 = 0
						local flag2 = true

						for k, v16 in v13 do
							total2 += not (v16 > 0) and 1 or v16

							if v14 <= total2 then
								v15 = k
								flag2 = false
								break
							end
						end

						if flag2 then
							v15 = #v13
						end
					end

					local v16 = math.min(#current, (math.max(v15, current3)))

					local v17 = not (v15 < current3) and 1 or v6
					local total2 = 0

					for i = 1, v16 do
						local v18 = current[i]
						total2 += not (v18 > 0) and 1 or v18
					end

					return (math.max(p8 + v6, total2 + v17))
				else
					local v13 = current
					local v14 = math.min(p8, total)
					local v15

					if v14 <= 0 then
						v15 = 0
					else
						local total2 = 0
						local flag2 = true

						for k, v16 in v13 do
							total2 += not (v16 > 0) and 1 or v16

							if v14 <= total2 then
								v15 = k
								flag2 = false
								break
							end
						end

						if flag2 then
							v15 = #v13
						end
					end

					local total2 = 0

					for i = 1, v15 do
						local v16 = current[i]
						total2 += not (v16 > 0) and 1 or v16
					end

					return (math.max(p8 + v6, total2 + 1))
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
			local v11, v12, v13

			if FFlagSduiProgressiveScrollMathFix then
				v11 = y
				v12 = y2
				v13 = y3 or v11

				if v13 <= 0 then
					return
				end
			else
				v11 = current2.AbsoluteCanvasSize.Y
				v12 = current2.AbsoluteWindowSize.Y
				local current3 = if p5 then p5.current else nil

				v13 = (if current3 ~= nil then current3.AbsoluteContentSize.Y else nil) or v11
			end

			local current3 = ref5.current

			if current3 ~= nil and v13 == current3 or v11 - v12 - y4 > math.max(0, p6) then
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
			local v14 = ref5
			local v15

			if FFlagSduiProgressiveScrollMathFix then
				v15 = y3 or y
			else
				local current5 = if p5 then p5.current else nil

				v15 = (if current5 ~= nil then current5.AbsoluteContentSize.Y else nil)
					or current2.AbsoluteCanvasSize.Y
			end

			v14.current = v15

			local current5 = if FFlagSduiProgressiveScrollMathFix then ref.current else nil

			setState(function(p8)
				if FFlagSduiProgressiveScrollMathFix then
					local v16 = current
					local v17 = math.min(p8, total)
					local v18

					if v17 <= 0 then
						v18 = 0
					else
						local total2 = 0
						local flag2 = true

						for k, v19 in v16 do
							total2 += not (v19 > 0) and 1 or v19

							if v17 <= total2 then
								v18 = k
								flag2 = false
								break
							end
						end

						if flag2 then
							v18 = #v16
						end
					end

					local v19 = math.min(#current, (math.max(v18, current5)))

					local v20 = not (v18 < current5) and 1 or v6
					local total2 = 0

					for i = 1, v19 do
						local v21 = current[i]
						total2 += not (v21 > 0) and 1 or v21
					end

					return (math.max(p8 + v6, total2 + v20))
				else
					local v16 = current
					local v17 = math.min(p8, total)
					local v18

					if v17 <= 0 then
						v18 = 0
					else
						local total2 = 0
						local flag2 = true

						for k, v19 in v16 do
							total2 += not (v19 > 0) and 1 or v19

							if v17 <= total2 then
								v18 = k
								flag2 = false
								break
							end
						end

						if flag2 then
							v18 = #v16
						end
					end

					local total2 = 0

					for i = 1, v18 do
						local v19 = current[i]
						total2 += not (v19 > 0) and 1 or v19
					end

					return (math.max(p8 + v6, total2 + 1))
				end
			end)
		end

		local function decideUnderfill()
			if flag then
				return
			end

			local v11

			if FFlagSduiProgressiveScrollMathFix then
				v11 = y3
			else
				local current3 = if p5 then p5.current else nil

				if current3 ~= nil then
					v11 = current3.AbsoluteContentSize.Y
				end
			end

			if v11 == nil or v11 <= 0 then
				return
			end

			local v12 = if FFlagSduiProgressiveScrollMathFix then y2 else current2.AbsoluteWindowSize.Y

			if v12 <= v11 then
				return
			end

			local current3 = ref5.current

			if current3 ~= nil and v11 == current3 then
				return
			end

			ref5.current = v11
			local v13 = ref5
			local v14

			if FFlagSduiProgressiveScrollMathFix then
				v14 = y3 or y
			else
				local current4 = if p5 then p5.current else nil

				v14 = (if current4 ~= nil then current4.AbsoluteContentSize.Y else nil)
					or current2.AbsoluteCanvasSize.Y
			end

			v13.current = v14

			local current4 = if FFlagSduiProgressiveScrollMathFix then ref.current else nil

			setState(function(p8)
				if FFlagSduiProgressiveScrollMathFix then
					local v15 = current
					local v16 = math.min(p8, total)
					local v17

					if v16 <= 0 then
						v17 = 0
					else
						local total2 = 0
						local flag2 = true

						for k, v18 in v15 do
							total2 += not (v18 > 0) and 1 or v18

							if v16 <= total2 then
								v17 = k
								flag2 = false
								break
							end
						end

						if flag2 then
							v17 = #v15
						end
					end

					local v18 = math.min(#current, (math.max(v17, current4)))

					local v19 = not (v17 < current4) and 1 or v6
					local total2 = 0

					for i = 1, v18 do
						local v20 = current[i]
						total2 += not (v20 > 0) and 1 or v20
					end

					return (math.max(p8 + v6, total2 + v19))
				else
					local v15 = current
					local v16 = math.min(p8, total)
					local v17

					if v16 <= 0 then
						v17 = 0
					else
						local total2 = 0
						local flag2 = true

						for k, v18 in v15 do
							total2 += not (v18 > 0) and 1 or v18

							if v16 <= total2 then
								v17 = k
								flag2 = false
								break
							end
						end

						if flag2 then
							v17 = #v15
						end
					end

					local total2 = 0

					for i = 1, v17 do
						local v18 = current[i]
						total2 += not (v18 > 0) and 1 or v18
					end

					return (math.max(p8 + v6, total2 + 1))
				end
			end)
		end

		local thread = nil
		local function scheduleUnderfillDecision()
			if thread then
				task.cancel(thread)
			end

			thread = task.delay(p7 / 1000, function()
				thread = nil

				if not flag then
					if flag then
						return
					end

					local v11

					if FFlagSduiProgressiveScrollMathFix then
						v11 = y3
					else
						local current3 = if p5 then p5.current else nil

						if current3 ~= nil then
							v11 = current3.AbsoluteContentSize.Y
						end
					end

					if v11 ~= nil then
						if v11 <= 0 then
							return
						end

						local v12 = if FFlagSduiProgressiveScrollMathFix then y2 else current2.AbsoluteWindowSize.Y

						if v12 <= v11 then
							return
						end

						local current3 = ref5.current

						if current3 ~= nil and v11 == current3 then
							return
						end

						ref5.current = v11
						local v13 = ref5
						local v14

						if FFlagSduiProgressiveScrollMathFix then
							v14 = y3 or y
						else
							local current4 = if p5 then p5.current else nil

							v14 = (if current4 ~= nil then current4.AbsoluteContentSize.Y else nil)
								or current2.AbsoluteCanvasSize.Y
						end

						v13.current = v14

						local current4 = if FFlagSduiProgressiveScrollMathFix then ref.current else nil

						setState(function(p8)
							if FFlagSduiProgressiveScrollMathFix then
								local v15 = current
								local v16 = math.min(p8, total)
								local v17

								if v16 <= 0 then
									v17 = 0
								else
									local total2 = 0
									local flag2 = true

									for k, v18 in v15 do
										total2 += not (v18 > 0) and 1 or v18

										if v16 <= total2 then
											v17 = k
											flag2 = false
											break
										end
									end

									if flag2 then
										v17 = #v15
									end
								end

								local v18 = math.min(#current, (math.max(v17, current4)))

								local v19 = not (v17 < current4) and 1 or v6
								local total2 = 0

								for i = 1, v18 do
									local v20 = current[i]
									total2 += not (v20 > 0) and 1 or v20
								end

								return (math.max(p8 + v6, total2 + v19))
							else
								local v15 = current
								local v16 = math.min(p8, total)
								local v17

								if v16 <= 0 then
									v17 = 0
								else
									local total2 = 0
									local flag2 = true

									for k, v18 in v15 do
										total2 += not (v18 > 0) and 1 or v18

										if v16 <= total2 then
											v17 = k
											flag2 = false
											break
										end
									end

									if flag2 then
										v17 = #v15
									end
								end

								local total2 = 0

								for i = 1, v17 do
									local v18 = current[i]
									total2 += not (v18 > 0) and 1 or v18
								end

								return (math.max(p8 + v6, total2 + 1))
							end
						end)
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

					if thread then
						task.cancel(thread)
					end

					thread = task.delay(p7 / 1000, function()
						thread = nil

						if not flag then
							if flag then
								return
							end

							local v11

							if FFlagSduiProgressiveScrollMathFix then
								v11 = y3
							else
								local current3 = if p5 then p5.current else nil

								if current3 ~= nil then
									v11 = current3.AbsoluteContentSize.Y
								end
							end

							if v11 ~= nil then
								if v11 <= 0 then
									return
								end

								local v12 = if FFlagSduiProgressiveScrollMathFix then y2 else current2.AbsoluteWindowSize.Y

								if v12 <= v11 then
									return
								end

								local current3 = ref5.current

								if current3 ~= nil and v11 == current3 then
									return
								end

								ref5.current = v11
								local v13 = ref5
								local v14

								if FFlagSduiProgressiveScrollMathFix then
									v14 = y3 or y
								else
									local current4 = if p5 then p5.current else nil

									v14 = (if current4 ~= nil then current4.AbsoluteContentSize.Y else nil)
										or current2.AbsoluteCanvasSize.Y
								end

								v13.current = v14

								local current4 = if FFlagSduiProgressiveScrollMathFix then ref.current else nil

								setState(function(p8)
									if FFlagSduiProgressiveScrollMathFix then
										local v15 = current
										local v16 = math.min(p8, total)
										local v17

										if v16 <= 0 then
											v17 = 0
										else
											local total2 = 0
											local flag2 = true

											for k, v18 in v15 do
												total2 += not (v18 > 0) and 1 or v18

												if v16 <= total2 then
													v17 = k
													flag2 = false
													break
												end
											end

											if flag2 then
												v17 = #v15
											end
										end

										local v18 = math.min(#current, (math.max(v17, current4)))

										local v19 = not (v17 < current4) and 1 or v6
										local total2 = 0

										for i = 1, v18 do
											local v20 = current[i]
											total2 += not (v20 > 0) and 1 or v20
										end

										return (math.max(p8 + v6, total2 + v19))
									else
										local v15 = current
										local v16 = math.min(p8, total)
										local v17

										if v16 <= 0 then
											v17 = 0
										else
											local total2 = 0
											local flag2 = true

											for k, v18 in v15 do
												total2 += not (v18 > 0) and 1 or v18

												if v16 <= total2 then
													v17 = k
													flag2 = false
													break
												end
											end

											if flag2 then
												v17 = #v15
											end
										end

										local total2 = 0

										for i = 1, v17 do
											local v18 = current[i]
											total2 += not (v18 > 0) and 1 or v18
										end

										return (math.max(p8 + v6, total2 + 1))
									end
								end)
							end
						end
					end)
				end),
				current2:GetPropertyChangedSignal("AbsoluteWindowSize"):Connect(function()
					y2 = current2.AbsoluteWindowSize.Y
					local current3 = ref4.current

					if current3 ~= nil and y - y2 < current3 then
						ref4.current = nil
						ref5.current = nil
						showNextBatchIfNearEnd()
					end

					if thread then
						task.cancel(thread)
					end

					thread = task.delay(p7 / 1000, function()
						thread = nil

						if not flag then
							if flag then
								return
							end

							local v11

							if FFlagSduiProgressiveScrollMathFix then
								v11 = y3
							else
								local current4 = if p5 then p5.current else nil

								if current4 ~= nil then
									v11 = current4.AbsoluteContentSize.Y
								end
							end

							if v11 ~= nil then
								if v11 <= 0 then
									return
								end

								local v12 = if FFlagSduiProgressiveScrollMathFix then y2 else current2.AbsoluteWindowSize.Y

								if v12 <= v11 then
									return
								end

								local current4 = ref5.current

								if current4 ~= nil and v11 == current4 then
									return
								end

								ref5.current = v11
								local v13 = ref5
								local v14

								if FFlagSduiProgressiveScrollMathFix then
									v14 = y3 or y
								else
									local current5 = if p5 then p5.current else nil

									v14 = (if current5 ~= nil then current5.AbsoluteContentSize.Y else nil)
										or current2.AbsoluteCanvasSize.Y
								end

								v13.current = v14

								local current5 = if FFlagSduiProgressiveScrollMathFix then ref.current else nil

								setState(function(p8)
									if FFlagSduiProgressiveScrollMathFix then
										local v15 = current
										local v16 = math.min(p8, total)
										local v17

										if v16 <= 0 then
											v17 = 0
										else
											local total2 = 0
											local flag2 = true

											for k, v18 in v15 do
												total2 += not (v18 > 0) and 1 or v18

												if v16 <= total2 then
													v17 = k
													flag2 = false
													break
												end
											end

											if flag2 then
												v17 = #v15
											end
										end

										local v18 = math.min(#current, (math.max(v17, current5)))

										local v19 = not (v17 < current5) and 1 or v6
										local total2 = 0

										for i = 1, v18 do
											local v20 = current[i]
											total2 += not (v20 > 0) and 1 or v20
										end

										return (math.max(p8 + v6, total2 + v19))
									else
										local v15 = current
										local v16 = math.min(p8, total)
										local v17

										if v16 <= 0 then
											v17 = 0
										else
											local total2 = 0
											local flag2 = true

											for k, v18 in v15 do
												total2 += not (v18 > 0) and 1 or v18

												if v16 <= total2 then
													v17 = k
													flag2 = false
													break
												end
											end

											if flag2 then
												v17 = #v15
											end
										end

										local total2 = 0

										for i = 1, v17 do
											local v18 = current[i]
											total2 += not (v18 > 0) and 1 or v18
										end

										return (math.max(p8 + v6, total2 + 1))
									end
								end)
							end
						end
					end)
				end)
			}

			local current3 = p5 and p5.current

			if current3 ~= nil then
				table.insert(
					connections,
					current3:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
						y3 = current3.AbsoluteContentSize.Y

						if ref2.current then
							showNextBatchIfNearEnd()
						end

						if thread then
							task.cancel(thread)
						end

						thread = task.delay(p7 / 1000, function()
							thread = nil

							if not flag then
								if flag then
									return
								end

								local v11

								if FFlagSduiProgressiveScrollMathFix then
									v11 = y3
								else
									local current4 = if p5 then p5.current else nil

									if current4 ~= nil then
										v11 = current4.AbsoluteContentSize.Y
									end
								end

								if v11 ~= nil then
									if v11 <= 0 then
										return
									end

									local v12 = if FFlagSduiProgressiveScrollMathFix then y2 else current2.AbsoluteWindowSize.Y

									if v12 <= v11 then
										return
									end

									local current4 = ref5.current

									if current4 ~= nil and v11 == current4 then
										return
									end

									ref5.current = v11
									local v13 = ref5
									local v14

									if FFlagSduiProgressiveScrollMathFix then
										v14 = y3 or y
									else
										local current5 = if p5 then p5.current else nil

										v14 = (if current5 ~= nil then current5.AbsoluteContentSize.Y else nil)
											or current2.AbsoluteCanvasSize.Y
									end

									v13.current = v14

									local current5 = if FFlagSduiProgressiveScrollMathFix then ref.current else nil

									setState(function(p8)
										if FFlagSduiProgressiveScrollMathFix then
											local v15 = current
											local v16 = math.min(p8, total)
											local v17

											if v16 <= 0 then
												v17 = 0
											else
												local total2 = 0
												local flag2 = true

												for k, v18 in v15 do
													total2 += not (v18 > 0) and 1 or v18

													if v16 <= total2 then
														v17 = k
														flag2 = false
														break
													end
												end

												if flag2 then
													v17 = #v15
												end
											end

											local v18 = math.min(#current, (math.max(v17, current5)))

											local v19 = not (v17 < current5) and 1 or v6
											local total2 = 0

											for i = 1, v18 do
												local v20 = current[i]
												total2 += not (v20 > 0) and 1 or v20
											end

											return (math.max(p8 + v6, total2 + v19))
										else
											local v15 = current
											local v16 = math.min(p8, total)
											local v17

											if v16 <= 0 then
												v17 = 0
											else
												local total2 = 0
												local flag2 = true

												for k, v18 in v15 do
													total2 += not (v18 > 0) and 1 or v18

													if v16 <= total2 then
														v17 = k
														flag2 = false
														break
													end
												end

												if flag2 then
													v17 = #v15
												end
											end

											local total2 = 0

											for i = 1, v17 do
												local v18 = current[i]
												total2 += not (v18 > 0) and 1 or v18
											end

											return (math.max(p8 + v6, total2 + 1))
										end
									end)
								end
							end
						end)
					end)
				)
			end
		else
			connections = {
				current2:GetPropertyChangedSignal("CanvasPosition"):Connect(showNextBatchIfNearEnd),
				current2:GetPropertyChangedSignal("AbsoluteWindowSize"):Connect(scheduleUnderfillDecision)
			}

			if p5 ~= nil and p5.current ~= nil then
				table.insert(
					connections,
					p5.current:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(scheduleUnderfillDecision)
				)
			end
		end

		if thread then
			task.cancel(thread)
		end

		thread = task.delay(p7 / 1000, function()
			thread = nil

			if not flag then
				if flag then
					return
				end

				local v11

				if FFlagSduiProgressiveScrollMathFix then
					v11 = y3
				else
					local current3 = if p5 then p5.current else nil

					if current3 ~= nil then
						v11 = current3.AbsoluteContentSize.Y
					end
				end

				if v11 ~= nil then
					if v11 <= 0 then
						return
					end

					local v12 = if FFlagSduiProgressiveScrollMathFix then y2 else current2.AbsoluteWindowSize.Y

					if v12 <= v11 then
						return
					end

					local current3 = ref5.current

					if current3 ~= nil and v11 == current3 then
						return
					end

					ref5.current = v11
					local v13 = ref5
					local v14

					if FFlagSduiProgressiveScrollMathFix then
						v14 = y3 or y
					else
						local current4 = if p5 then p5.current else nil

						v14 = (if current4 ~= nil then current4.AbsoluteContentSize.Y else nil)
							or current2.AbsoluteCanvasSize.Y
					end

					v13.current = v14

					local current4 = if FFlagSduiProgressiveScrollMathFix then ref.current else nil

					setState(function(p8)
						if FFlagSduiProgressiveScrollMathFix then
							local v15 = current
							local v16 = math.min(p8, total)
							local v17

							if v16 <= 0 then
								v17 = 0
							else
								local total2 = 0
								local flag2 = true

								for k, v18 in v15 do
									total2 += not (v18 > 0) and 1 or v18

									if v16 <= total2 then
										v17 = k
										flag2 = false
										break
									end
								end

								if flag2 then
									v17 = #v15
								end
							end

							local v18 = math.min(#current, (math.max(v17, current4)))

							local v19 = not (v17 < current4) and 1 or v6
							local total2 = 0

							for i = 1, v18 do
								local v20 = current[i]
								total2 += not (v20 > 0) and 1 or v20
							end

							return (math.max(p8 + v6, total2 + v19))
						else
							local v15 = current
							local v16 = math.min(p8, total)
							local v17

							if v16 <= 0 then
								v17 = 0
							else
								local total2 = 0
								local flag2 = true

								for k, v18 in v15 do
									total2 += not (v18 > 0) and 1 or v18

									if v16 <= total2 then
										v17 = k
										flag2 = false
										break
									end
								end

								if flag2 then
									v17 = #v15
								end
							end

							local total2 = 0

							for i = 1, v17 do
								local v18 = current[i]
								total2 += not (v18 > 0) and 1 or v18
							end

							return (math.max(p8 + v6, total2 + 1))
						end
					end)
				end
			end
		end)

		if FFlagSduiProgressiveScrollMathFix and (v10 or ref2.current) then
			showNextBatchIfNearEnd()
		end

		return function()
			flag = true

			if thread then
				task.cancel(thread)
			end

			for k, connection in connections do
				connection:Disconnect()
			end
		end
	end, { v9, v6, total, p4, p5, p6, current, p7 })

	return v8, v9
end

return useProgressiveItemCapOnScroll
