class User < ApplicationRecord
    validates :role, inclusion: {in: ["student", "teacher"]}
end
