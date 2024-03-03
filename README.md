# Design-Patterns

### Singleton

Purpose: Avoid multiple instance of a class.

C# Code:
```
namespace DesignPattern
{
    class Singleton
    {
        private static Singleton Instance;
        private static object locker = new object(); //Locker for blocking multithread to create multi instances of the class

        private string name;
        private Singleton(string name)  //Private Constructor to avoid declare object of the class
        {
            this.name = name;
        }
        public static Singleton GetInstance(string name)
        {
            if (Instance == null)  //Double null checking for multithreads
                                   //Threads dont need to be locked if instance is not null
            {
                lock (locker)
                {
                    if (Instance == null)
                    {
                        Instance = new Singleton(name);
                    }
                }
            }

            return Instance;
        }

        public string GetName()
        {
            return name;
        }
    }
}


using DesignPattern;

Singleton ob1 = Singleton.GetInstance("RAFIQ");
Singleton ob2 = Singleton.GetInstance("KARIM");

//Both will print RAFIQ as instance creation is done once
Console.WriteLine(ob1.GetName());
Console.WriteLine(ob2.GetName());
```

### Factory

Purpose: Provide instance from factory according to user preferences.

C# Code: 
```
namespace DesignPattern
{
    interface iPizza
    {
        void Eat();
    }

    class VegPizza : iPizza
    {
        public void Eat()
        {
            Console.WriteLine("Eating veg pizza...");
        }
    }

    class NonVegPizza : iPizza
    {
        public void Eat()
        {
            Console.WriteLine("Eating non veg pizza...");
        }
    }

    enum PizzaType
    {
        Veg, 
        NonVeg
    }

    class Waiter
    {
        public iPizza GetPizza(PizzaType type)
        {
            switch (type)
            {
                case PizzaType.Veg: return new VegPizza();
                case PizzaType.NonVeg: return new NonVegPizza();
            }

            return null;
        }
    }
}

using DesignPattern;

Waiter waiter = new Waiter();
iPizza pizza = waiter.GetPizza(PizzaType.NonVeg); //Get non veg pizza instance
pizza.Eat();
```
### Abstruct Factory

Purpose: Extension of Factory pattern. User preferences are given once at the beginning, multiple instance of 
different class will be created according to this.

C# Code:
```
namespace DesignPattern
{
    interface iPizza
    {
        void Eat();
    }

    class VegPizza : iPizza
    {
        public void Eat()
        {
            Console.WriteLine("Eating veg pizza...");
        }
    }

    class NonVegPizza : iPizza
    {
        public void Eat()
        {
            Console.WriteLine("Eating non veg pizza...");
        }
    }

    interface iBurger
    {
        void Eat();
    }

    class VegBurger : iBurger
    {
        public void Eat()
        {
            Console.WriteLine("Eating veg burger...");
        }
    }

    class NonVegBurger : iBurger
    {
        public void Eat()
        {
            Console.WriteLine("Eating non veg burger...");
        }
    }

    interface iChef
    {
        iPizza PreparePizza();
        iBurger PrepareBurger();
    }

    class VegChef : iChef
    {
        public iBurger PrepareBurger()
        {
            return new VegBurger();
        }

        public iPizza PreparePizza()
        {
            return new VegPizza();
        }
    }

    class NonVegChef : iChef
    {
        public iBurger PrepareBurger()
        {
            return new NonVegBurger();
        }

        public iPizza PreparePizza()
        {
            return new NonVegPizza();
        }
    }

    enum FoodType
    {
        Veg, 
        NonVeg
    }

    class Waiter
    {
        private iChef chef;

        public Waiter(FoodType type)
        {
            if(type == FoodType.Veg) chef = new VegChef();
            else chef = new NonVegChef();
        }
        public iPizza GetPizza()
        {
            return chef.PreparePizza();
        }

        public iBurger GetBurger()
        {
            return chef.PrepareBurger();
        }
    }
}

using DesignPattern;

Waiter waiter = new Waiter(FoodType.Veg); //Preferences is given initially

iPizza pizza = waiter.GetPizza();
pizza.Eat();

iBurger burger = waiter.GetBurger();
burger.Eat();
```

### Prototype

Purpose: Deep clone and equality check

C# Code:
```
namespace DesignPattern
{
    class Prototype1 : ICloneable, IEquatable<Prototype1>
    {
        public Prototype2 prototype2 = new();
        public object Clone()
        {
            Prototype1 prototype1 = (Prototype1)this.MemberwiseClone();
            prototype1.prototype2 = (Prototype2)prototype2.Clone();
            return prototype1;
        }

        public bool Equals(Prototype1? other)
        {
            if(other == null) return false;
            if(other.prototype2.Equals(this.prototype2)) return false;
            return true;
        }
    }

    class Prototype2 : ICloneable, IEquatable<Prototype2>
    {
        public string name;
        public object Clone()
        {
            return this.MemberwiseClone();
        }

        public bool Equals(Prototype2? other)
        {
            if (other == null || name != other.name) return false;
            return true;
        }
    }
}

using DesignPattern;

Prototype1 prototype11 = new Prototype1();
prototype11.prototype2.name = "RAFIQ";

Prototype1 prototype12 = (Prototype1)prototype11.Clone();
prototype11.prototype2.name = "KARIM";

//Both will print different names as they are different object.
Console.WriteLine(prototype11.prototype2.name);
Console.WriteLine(prototype12.prototype2.name);
```

### Builder

Purpose: Break down complex object constructor. Make it step by step.

C# Code:
```
namespace DesignPattern
{
    class CellPhone
    {
        private string brand;
        private string os;
        private string processor;
        private double screenSize;
        private int battery;
        private int camera;

        public CellPhone(string brand, string os, string processor, double screenSize, int battery, int camera)
        {
            this.brand = brand;
            this.os = os;
            this.processor = processor;
            this.screenSize = screenSize;
            this.battery = battery;
            this.camera = camera;
        }

        public void Print()
        {
            Console.WriteLine(brand + " " + os + " " + processor + " " + screenSize + " " + battery + " " + camera);
        }
    }

    interface ICellPhoneBuilder
    {
        CellPhone GetCellPhone();
        ICellPhoneBuilder SetOs(string os);
        ICellPhoneBuilder SetProcessor(string processor);
        ICellPhoneBuilder SetScreenSize(double screenSize);
        ICellPhoneBuilder SetBattery(int battery);
        ICellPhoneBuilder SetCamera(int camera);
    }

    class SamsungCellPhoneBuilder : ICellPhoneBuilder
    {
        private string brand = "Samsung";
        private string os;
        private string processor;
        private double screenSize;
        private int battery;
        private int camera;

        public CellPhone GetCellPhone()
        {
            return new CellPhone(brand,  os, processor, screenSize, battery, camera);
        }
        ICellPhoneBuilder ICellPhoneBuilder.SetOs(string os) { this.os = os; return this; }
        ICellPhoneBuilder ICellPhoneBuilder.SetProcessor(string processor) { this.processor = processor; return this; }
        ICellPhoneBuilder ICellPhoneBuilder.SetScreenSize(double screenSize) { this.screenSize = screenSize; return this; }
        ICellPhoneBuilder ICellPhoneBuilder.SetBattery(int battery) { this.battery = battery; return this; }
        ICellPhoneBuilder ICellPhoneBuilder.SetCamera(int camera) { this.camera = camera; return this; }
    }

    class AppleCellPhoneBuilder : ICellPhoneBuilder
    {
        private string brand = "Apple";
        private string os;
        private string processor;
        private double screenSize;
        private int battery;
        private int camera;

        public CellPhone GetCellPhone()
        {
            return new CellPhone(brand, os, processor, screenSize, battery, camera);
        }
        ICellPhoneBuilder ICellPhoneBuilder.SetOs(string os) { this.os = os; return this; }
        ICellPhoneBuilder ICellPhoneBuilder.SetProcessor(string processor) { this.processor = processor; return this; }
        ICellPhoneBuilder ICellPhoneBuilder.SetScreenSize(double screenSize) { this.screenSize = screenSize; return this; }
        ICellPhoneBuilder ICellPhoneBuilder.SetBattery(int battery) { this.battery = battery; return this; }
        ICellPhoneBuilder ICellPhoneBuilder.SetCamera(int camera) { this.camera = camera; return this; }
    }

    static class Director
    {
        public static CellPhone ConstructSamsungCellPhone()
        {
            ICellPhoneBuilder builder = new SamsungCellPhoneBuilder();
            return builder.SetCamera(120).SetProcessor("INTEL").GetCellPhone(); 
        }

        public static CellPhone ConstructAppleCellPhone()
        {
            ICellPhoneBuilder builder = new AppleCellPhoneBuilder();
            return builder.SetCamera(20).SetOs("IOS").GetCellPhone();
        }
    }
}

using DesignPattern;

CellPhone cellPhone1 = Director.ConstructSamsungCellPhone();
CellPhone cellPhone2 = Director.ConstructAppleCellPhone();

cellPhone1.Print();
cellPhone2.Print();
```
