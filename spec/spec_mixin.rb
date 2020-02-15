module SpecMixin
  def reset_tmp_dir
    system "cp spec/fixtures/*.yml tmp/"
  end
end