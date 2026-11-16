local function createImmersiveChromeMachine(data, p)
	local now = p.now

	local flag = true
	local count = 0
	local v = nil
	local v2 = 0
	local v3 = true

	local v4 = false
	local v5 = false
	local v6 = false
	local v7 = now()
	local v8 = -1e999

	local function applyShow(p2: string) -- 6 equivalent calls inferred from this helper
		if v6 then
			return
		end

		count = 0
		v7 = now()

		if flag then
			return
		end

		flag = true
		p.setChromeVisible(true, p2)
	end

	local function applyHide(value: string?) -- 2 equivalent calls inferred from this helper
		if not flag then
			return
		end

		flag = false
		v8 = now()
		p.setChromeVisible(false, value or "advance")
	end

	local function tryHide()
		if v5 or not flag or count < data.hideAfterAdvances or v4 and not v3 then
			return
		end

		if now() - v7 < data.shownDwellMs then
			return
		end

		applyHide() -- inferred equivalent call
	end

	return {
		onActiveUpdate = function(p2: number, flag2: boolean, flag3: boolean)
			local v9 = v

			if v9 == nil then
				v = p2
				v3 = flag2
				v4 = flag2
			else
				local v10 = p2 - v9
				v = p2

				if v10 == 0 then
					if flag3 then
						return
					end

					if flag2 then
						local v11 = not v3 and v4
						v3 = true
						v4 = true

						if v11 then
							v7 = now()
						end
					else
						if not v3 then
							return
						end

						v3 = false

						if not v4 or v5 or now() - v8 < data.hiddenCooldownMs then
							return
						end

						applyShow("pause") -- inferred equivalent call
					end
				else
					if v2 > 0 and v2 <= p2 then
						applyShow("endOfFeed") -- inferred equivalent call
					elseif v10 == 1 then
						count += 1

						if
							not v5
							and flag
							and not (count < data.hideAfterAdvances)
							and (not v4 or v3)
							and not (now() - v7 < data.shownDwellMs)
						then
							applyHide() -- inferred equivalent call
						end
					elseif v10 < 0 then
						applyShow("reverse") -- inferred equivalent call
					else
						count = 0
					end

					v4 = false
				end
			end
		end,
		setForceShow = function(flag2: boolean)
			if flag2 == v5 then
				return
			end

			v5 = flag2

			if v5 then
				applyShow("force") -- inferred equivalent call
			end
		end,
		setForceHide = function(flag2: boolean)
			if flag2 == v6 then
				return
			end

			v6 = flag2

			if v6 then
				if not flag then
					return
				end

				flag = false
				v8 = now()
				p.setChromeVisible(false, "force")
			else
				applyShow("reveal") -- inferred equivalent call
			end
		end,
		setCount = function(p2: number)
			v2 = p2
		end,
		reveal = function()
			applyShow("reveal") -- inferred equivalent call
		end,
		isVisible = function()
			return flag
		end
	}
end

return createImmersiveChromeMachine
