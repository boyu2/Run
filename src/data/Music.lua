local MusicData = require("data.MusicData")
local Music = class("Music")

function Music:ctor()
    self:reset()
end

function Music:reset()
    self.curMusic = nil
    self.moreIndex = 0
end

function Music:load(chapter)
    self.curMusic = MusicData[MusicData.chapters[chapter]]
end

function Music:getMore()
    self.moreIndex = self.moreIndex + 1
    return self.curMusic.data[self.moreIndex]
end

return Music