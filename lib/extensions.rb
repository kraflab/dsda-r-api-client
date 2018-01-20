class Hash
  def except(*keys)
    dup.except!(*keys)
  end

  def except!(*keys)
    keys.each { |key| delete(key) }
    self
  end

  def slice(*keys)
    keys.each_with_object(self.class.new) { |k, hash| hash[k] = self[k] if has_key?(k) }
  end

  def includes_all?(keys)
    keys.each do |key|
      return false if !include?(key)
    end
    true
  end

  def includes_only?(allowed_keys)
    keys.each do |key|
      return false unless allowed_keys.include?(key)
    end
    true
  end
end
