module Enumerable

    def my_each
        index = 0
        while index  < self.size
            yield(self[index])
            index += 1
        end
        self
    end

    def my_each_with_index
        index = 0
        while index < self.size
            yield(self[index], index)
            index += 1
        end
        self
    end

    def my_select
        result_array = Array.new
        self.my_each do |element|
            if yield(element)
                result_array << element
            end
        end
        result_array
    end

    def my_all?
        fallback_proc = Proc.new{|object| object}
        if block_given?
            self.my_each { |element| return false unless yield(element) }
        else
            self.my_each { |element| return false unless fallback_proc.call(element) }
        end
        true
    end

    def my_any?
        fallback_proc = Proc.new { |object| object }
        if block_given?
            self.my_each { |element| return true if yield(element)}
        end
        false
    end

    def my_none?
        fallback_proc = Proc.new { |object| object }
        if block_given?
            self.my_each { |element| return false if yield(element) }
        else
            self.my_each { |element| return false if fallback_proc.call(element) }
        end
        true
    end

    def my_count(arg = nil)
        enum = 0
        if arg
            self.my_each { |element| enum += 1 if element == arg }
        elsif block_given?
            self.my_each { |element| enum += 1 if yield(element) }
        else
            self.my_each { |element| enum += 1 if element }
        end
        enum
    end

    def my_map someProc = 0
        new_array = []
        if block_given?
            self.my_each { |element| new_array << yield(element) }
        elsif someProc.class == Proc
            self.my_each { |element| new_array << someProc.call(element) }
        else
            new_array = self.to_enum
        end
        new_array
    end

    def my_inject(arg = 0, oper = :+)
        total = 0
        case arg
        when Symbol
            oper = arg
            total = 1 if oper == :* || oper == :/
        else
            total = arg
        end
        if block_given?
            self.my_each { |element| total = yield(total, element) }
        else
            self.my_each { |element| total = total.method(oper).call(element) }
        end
        total
    end

end

def multiply_els(arr = [])
    arr.my_inject(:*)
end