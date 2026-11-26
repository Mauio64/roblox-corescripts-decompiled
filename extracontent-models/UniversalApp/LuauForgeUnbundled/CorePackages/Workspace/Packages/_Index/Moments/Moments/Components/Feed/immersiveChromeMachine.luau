local function createImmersiveChromeMachine(data, p2)
	local now = p2.now

	local flag = true
	local count = 0
	local v5 = nil
	local v6 = 0
	local v7 = true

	local v8 = false
	local v9 = false
	local v10 = false
	local v11 = now()
	local v12 = -1e999

	local function applyShow(p3)
		if v10 then
			return
		end

		count = 0
		v11 = now()

		if flag then
			return
		end

		flag = true
		p2.setChromeVisible(true, p3)
	end

	local function applyHide(value)
		if not flag then
			return
		end

		flag = false
		v12 = now()
		p2.setChromeVisible(false, value or "advance")
	end

	local function tryHide()
		if v9 or not flag or count < data.hideAfterAdvances or v8 and not v7 then
			return
		end

		if now() - v11 < data.shownDwellMs or not flag then
			return
		end

		flag = false
		v12 = now()
		p2.setChromeVisible(false, "advance")
	end

	return {
		onActiveUpdate = function(p3, p4, p5)
			local v13 = v5

			if v13 == nil then
				v5 = p3
				v7 = p4
				v8 = p4
			else
				local v14 = p3 - v13
				v5 = p3

				if v14 == 0 then
					if p5 then
						return
					end

					if p4 then
						local v15 = not v7 and v8
						v7 = true
						v8 = true

						if v15 then
							v11 = now()
						end
					else
						if not v7 then
							return
						end

						v7 = false

						if not v8 or v9 or now() - v12 < data.hiddenCooldownMs or v10 then
							return
						end

						count = 0
						v11 = now()

						if flag then
							return
						end

						flag = true
						p2.setChromeVisible(true, "pause")
					end
				else
					if v6 > 0 and v6 <= p3 then
						if not v10 then
							count = 0
							v11 = now()

							if not flag then
								flag = true
								p2.setChromeVisible(true, "endOfFeed")
							end
						end
					elseif v14 == 1 then
						count += 1

						if
							not v9
							and flag
							and not (count < data.hideAfterAdvances)
							and (not v8 or v7)
							and not (now() - v11 < data.shownDwellMs)
							and flag
						then
							flag = false
							v12 = now()
							p2.setChromeVisible(false, "advance")
						end
					elseif v14 < 0 then
						if not v10 then
							count = 0
							v11 = now()

							if not flag then
								flag = true
								p2.setChromeVisible(true, "reverse")
							end
						end
					else
						count = 0
					end

					v8 = false
				end
			end
		end,
		setForceShow = function(p3)
			if p3 == v9 then
				return
			end

			v9 = p3

			if v9 then
				if v10 then
					return
				end

				count = 0
				v11 = now()

				if flag then
					return
				end

				flag = true
				p2.setChromeVisible(true, "force")
			end
		end,
		setForceHide = function(p3)
			if p3 == v10 then
				return
			end

			v10 = p3

			if v10 then
				if not flag then
					return
				end

				flag = false
				v12 = now()
				p2.setChromeVisible(false, "force")
			else
				if v10 then
					return
				end

				count = 0
				v11 = now()

				if flag then
					return
				end

				flag = true
				p2.setChromeVisible(true, "reveal")
			end
		end,
		setCount = function(p3)
			v6 = p3
		end,
		reveal = function()
			if v10 then
				return
			end

			count = 0
			v11 = now()

			if flag then
				return
			end

			flag = true
			p2.setChromeVisible(true, "reveal")
		end,
		isVisible = function()
			return flag
		end
	}
end

return createImmersiveChromeMachine
