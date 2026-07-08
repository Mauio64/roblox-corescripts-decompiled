local TextService = game:GetService("TextService")
local UserGameSettings = UserSettings():GetService("UserGameSettings")
local Parent = script:FindFirstAncestor("TextSize").Parent
local Signals = require(Parent.Signals)

local function calculateTextSizeOffset() -- line: 26
	-- upvalues: TextService (copy)
	local co = coroutine.create(function() -- line: 27
		-- upvalues: TextService (copy)
		local v17 = Font.fromEnum(Enum.Font.BuilderSans)
		local ok, result = pcall(function() -- line: 31
			-- upvalues: TextService (copy), v17 (copy)
			return TextService:GetTextSizeOffsetAsync(0, v17)
		end)

		if not ok then
			warn(result)

			return 0
		end

		return result or 0
	end)

	return (function(p1: thread, b1: boolean, ...) -- line: 10
		if not b1 then
			return nil
		end

		if coroutine.status(p1) ~= "dead" then
			return nil
		end

		return ...
	end)(co, coroutine.resume(co)) or 0
end
local function createTextSizeStore() -- line: 45
	-- upvalues: Signals (copy), TextService (copy), UserGameSettings (copy)
	local createSignal = Signals.createSignal
	local co = coroutine.create(function() -- line: 27
		-- upvalues: TextService (copy)
		local v22 = Font.fromEnum(Enum.Font.BuilderSans)
		local ok, result = pcall(function() -- line: 31
			-- upvalues: TextService (copy), v22 (copy)
			return TextService:GetTextSizeOffsetAsync(0, v22)
		end)

		if not ok then
			warn(result)

			return 0
		end

		return result or 0
	end)
	local v12, v13 = createSignal((function(p2: thread, b2: boolean, ...) -- line: 10
		if not b2 then
			return nil
		end

		if coroutine.status(p2) ~= "dead" then
			return nil
		end

		return ...
	end)(co, coroutine.resume(co)) or 0)
	local connection = UserGameSettings:GetPropertyChangedSignal("PreferredTextSize"):Connect(function() -- line: 48
		-- upvalues: v13 (copy), TextService (copy)
		local v27 = v13
		local co2 = coroutine.create(function() -- line: 27
			-- upvalues: TextService (copy)
			local v29 = Font.fromEnum(Enum.Font.BuilderSans)
			local ok, result = pcall(function() -- line: 31
				-- upvalues: TextService (copy), v29 (copy)
				return TextService:GetTextSizeOffsetAsync(0, v29)
			end)

			if not ok then
				warn(result)

				return 0
			end

			return result or 0
		end)

		v27((function(p3: thread, b3: boolean, ...) -- line: 10
			if not b3 then
				return nil
			end

			if coroutine.status(p3) ~= "dead" then
				return nil
			end

			return ...
		end)(co2, coroutine.resume(co2)) or 0)
	end)

	return {
		getTextSizeOffset = v12,
		cleanup = function() -- line: 54
			-- upvalues: connection (ref)
			if connection then
				connection:Disconnect()
				connection = nil
			end
		end
	}
end

return createTextSizeStore
