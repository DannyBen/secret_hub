module SpecMixin
  def reset_tmp_dir
    system "cp spec/fixtures/secrets.yml tmp/secrets.yml"
  end
end