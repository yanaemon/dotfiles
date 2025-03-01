local map = hs.keycodes.map
local keyDown = hs.eventtap.event.types.keyDown
local flagsChanged = hs.eventtap.event.types.flagsChanged

local SOURCE_ID_EN = "com.apple.keylayout.ABC" -- 「英数」の入力ソースID
local SOURCE_ID_JA = "com.apple.inputmethod.Kotoeri.RomajiTyping.Japanese" -- 「かな」の入力ソースID
local INPUT_METHOD_KEY_EN = 0x66
local INPUT_METHOD_KEY_JA = 0x68

-- 「入力ソースを切り替えるショートカット」を押す
local function switchInputSource(inputMethodKey)
    -- hs.eventtap.keyStroke({"ctrl", "alt"}, "space", 0)
    hs.eventtap.keyStroke({}, inputMethodKey, 0)
end

local isCmdAsModifier = false

local function switchInputSourceEvent(event)
    local eventType = event:getType()
    local keyCode = event:getKeyCode()
    local flags = event:getFlags()
    local isCmd = flags['cmd']

    if eventType == keyDown then
        if isCmd then
            isCmdAsModifier = true
        end
    elseif eventType == flagsChanged then
        if not isCmd then
            if isCmdAsModifier == false then
                local currentSourceID = hs.keycodes.currentSourceID()
                print('keyCode', keyCode)
                print('current source', currentSourceID)
                -- print('current inputMethod', hs.keycodes.inputMethod())

                -- 入力された command キーの入力ソースと現在の入力ソースが異なるときだけ実行
                if keyCode == map['cmd'] and currentSourceID ~= SOURCE_ID_EN then
                    print('switch to EN')
                    switchInputSource(INPUT_METHOD_KEY_EN)
                elseif keyCode == map['rightcmd'] and currentSourceID ~= SOURCE_ID_JA then
                    print('switch to JA')
                    switchInputSource(INPUT_METHOD_KEY_JA)
                end
            end
            isCmdAsModifier = false
        end
    end
end

eventTap = hs.eventtap.new({keyDown, flagsChanged}, switchInputSourceEvent)
eventTap:start()
