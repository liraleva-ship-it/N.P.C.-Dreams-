module Cache
  def self.normal_bitmap(path)
    @cache[path] = try_load(path) unless include?(path)
    @cache[path]
  rescue RGSSError
    @errors ||= {}
    unless @errors[path]
      msgbox(
        "ビットマップの生成に失敗しました\n",
        "ゲームを再起動してください\n\n",
        "Path: #{path.inspect}\n\n",
        caller[2,5].join("\n")
      )
      @__errors[path] = true
    end
    @cache[path] = empty_bitmap
  end
  def self.try_load(path)
    Bitmap.new(path)
  rescue RGSSError
    clear   # 使用中の画像解放防止のためGCに任せる
    Bitmap.new(path)
  end
end