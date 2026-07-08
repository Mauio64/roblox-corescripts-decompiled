local function createImmersiveChromeMachine(t1: {[any]: any}, t2: {[any]: any}) -- line: 68
	local now = t2.now
	local u5 = true
	local n1 = 0
	local u7 = nil
	local n2 = 0
	local u9 = true
	local u10 = false
	local u11 = false
	local u12 = false
	local u13 = now()
	local n3 = -1e999

	local function applyShow(s1: string) -- line: 89
		-- upvalues: u12 (ref), n1 (ref), u13 (ref), now (copy), u5 (ref), t2 (copy)
		if u12 then
			return
		end

		n1 = 0
		u13 = now()

		if u5 then
			return
		end

		u5 = true
		t2.setChromeVisible(true, s1)
	end
	local function applyHide(s2: string?) -- line: 105
		-- upvalues: u5 (ref), n3 (ref), now (copy), t2 (copy)
		if not u5 then
			return
		end

		u5 = false
		n3 = now()
		t2.setChromeVisible(false, s2 or "advance")
	end
	local function tryHide() -- line: 114
		-- upvalues: u11 (ref), u5 (ref), n1 (ref), t1 (copy), u10 (ref), u9 (ref), now (copy), u13 (ref), n3 (ref), t2 (copy)
		if u11 or not u5 then
			return
		end

		if n1 < t1.hideAfterAdvances then
			return
		end

		if u10 and not u9 then
			return
		end

		if now() - u13 < t1.shownDwellMs then
			return
		end

		if not u5 then
			return
		end

		u5 = false
		n3 = now()
		t2.setChromeVisible(false, "advance")
	end

	return {
		onActiveUpdate = function(n4: number, b1: boolean, b2: boolean) -- line: 167
			-- upvalues: u7 (ref), u9 (ref), u10 (ref), n2 (ref), u12 (ref), n1 (ref), u13 (ref), now (copy), u5 (ref), t2 (copy), u11 (ref), t1 (copy), n3 (ref)
			local v26 = u7

			if v26 == nil then
				u7 = n4
				u9 = b1
				u10 = b1

				return
			end

			local v27 = n4 - v26

			u7 = n4

			if v27 ~= 0 then
				if n2 > 0 and n4 >= n2 then
					if not u12 then
						n1 = 0
						u13 = now()

						if not u5 then
							u5 = true
							t2.setChromeVisible(true, "endOfFeed")
						end
					end
				elseif v27 == 1 then
					n1 += 1

					if not u11 and u5 and not (n1 < t1.hideAfterAdvances) and ((not u10 or u9) and not (now() - u13 < t1.shownDwellMs) and u5) then
						u5 = false
						n3 = now()
						t2.setChromeVisible(false, "advance")
					end
				elseif v27 < 0 then
					if not u12 then
						n1 = 0
						u13 = now()

						if not u5 then
							u5 = true
							t2.setChromeVisible(true, "reverse")
						end
					end
				else
					n1 = 0
				end

				u10 = false

				return
			end

			if b2 then
				return
			end

			if b1 then
				local v28 = not u9 and u10

				u9 = true
				u10 = true

				if v28 then
					u13 = now()
				end

				return
			end

			if not u9 then
				return
			end

			u9 = false

			if not u10 then
				return
			end

			if u11 then
				return
			end

			if now() - n3 < t1.hiddenCooldownMs then
				return
			end

			if u12 then
				return
			end

			n1 = 0
			u13 = now()

			if u5 then
				return
			end

			u5 = true
			t2.setChromeVisible(true, "pause")
		end,
		setForceShow = function(b3: boolean) -- line: 134
			-- upvalues: u11 (ref), u12 (ref), n1 (ref), u13 (ref), now (copy), u5 (ref), t2 (copy)
			if b3 == u11 then
				return
			end

			u11 = b3

			if u11 then
				if u12 then
					return
				end

				n1 = 0
				u13 = now()

				if u5 then
					return
				end

				u5 = true
				t2.setChromeVisible(true, "force")
			end
		end,
		setForceHide = function(b4: boolean) -- line: 145
			-- upvalues: u12 (ref), u5 (ref), n3 (ref), now (copy), t2 (copy), n1 (ref), u13 (ref)
			if b4 == u12 then
				return
			end

			u12 = b4

			if u12 then
				if not u5 then
					return
				end

				u5 = false
				n3 = now()
				t2.setChromeVisible(false, "force")

				return
			end

			if u12 then
				return
			end

			n1 = 0
			u13 = now()

			if u5 then
				return
			end

			u5 = true
			t2.setChromeVisible(true, "reveal")
		end,
		setCount = function(n5: number) -- line: 158
			-- upvalues: n2 (ref)
			n2 = n5
		end,
		reveal = function() -- line: 245
			-- upvalues: u12 (ref), n1 (ref), u13 (ref), now (copy), u5 (ref), t2 (copy)
			if u12 then
				return
			end

			n1 = 0
			u13 = now()

			if u5 then
				return
			end

			u5 = true
			t2.setChromeVisible(true, "reveal")
		end,
		isVisible = function() -- line: 255
			-- upvalues: u5 (ref)
			return u5
		end
	}
end

return createImmersiveChromeMachine
