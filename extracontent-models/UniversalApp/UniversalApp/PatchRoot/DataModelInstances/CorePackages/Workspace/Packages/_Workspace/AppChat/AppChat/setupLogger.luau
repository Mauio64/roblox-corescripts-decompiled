local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local Logger = require(AppChatParent.Loggers).Logger
local beforeAll = require(AppChatParent.Dev.JestGlobals).beforeAll
local Logger2 = require(AppChat.Logger)

beforeAll(function() -- line: 10
	-- upvalues: Logger2 (copy), Logger (copy)
	Logger2:setParent(Logger)
end)
