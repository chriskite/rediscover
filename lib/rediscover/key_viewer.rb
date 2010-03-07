module KeyViewer
  def on_save(&block)
    @on_save_block = block
  end

  def do_on_save
    @on_save_block.call() if @on_save_block
  end

  def on_close(&block)
    @on_close_block = block
  end

  def do_on_close
    @on_close_block.call() if @on_close_block
  end
end
