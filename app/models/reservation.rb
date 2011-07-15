class Reservation < ActiveRecord::Base
  
  has_event_calendar
  
  belongs_to :user
  has_and_belongs_to_many :items
  
  before_save :calculate_fee
  before_validation :generate_name
  validates_presence_of :name
  validate :must_have_one_item
  validate :date_at_least_today
  validate :ensure_duration_positive
  validate :fee_must_be_at_least_1_time
  before_create :no_overlap_for_items
  validates_presence_of :start_at, :end_at; :fee
  
  #boring validations
  validates_presence_of :firstname 
  validates_presence_of :lastname, :address, :phone, :email 
  
  protected
  
    def duration
      return (self.end_at-self.start_at)/60/60/24.ceil.to_i
    end
    
    def generate_name
      
      self.name = ""
      
      for item in self.items
        self.name = self.name+item.title+" "
      end
      
      self.name = self.name+" are being rented"
      
    end
    
    def date_at_least_today
      errors.add(:start_at, "must be at least present moment") if
        self.start_at < Time.now
    end
    
    def must_have_one_item
      errors.add(:items, "must be selected") if 
        self.items.length < 1
    end 
  
  
    def ensure_duration_positive
      errors.add(:end_at, "must be after start") if
        duration <= 0
    end
    
    def fee_must_be_at_least_1_time

    end
    
  
    def calculate_fee
      fee = 0.to_f
      for item in self.items 
        fee = fee+item.price*duration.to_f
      end
    
      #round fee to closest integer, typecast back to float
      fee = fee.ceil.to_f
    
      self.fee = fee
    
    end
    
    def no_overlap_for_items
      overlap = false
      reservations = Reservation.all
      
      for reservation in reservations
        
        #does the reservation being compared have the same item?
        for item in reservation.items
          if self.items.include?(item)
              
              #is the included item also in use in the same time?
              if ((reservation.start_at - self.end_at) * (self.start_at - reservation.end_at) >= 0)
                overlap = true
              end
                
          end
        end
      end
      
      errors.add(:start_at, "There is a prior reservation for this equipment during this time") if
        overlap == true
        
    end
    
  
end
