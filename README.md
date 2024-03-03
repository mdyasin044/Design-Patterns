# Design-Patterns
## Creational Design patterns
### 1. Singleton

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

### 2. Factory

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
### 3. Abstruct Factory

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

### 4. Prototype

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

### 5. Builder

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

## Structural Design patterns

### 1. Adapter

Purpose: Adapt a class and a interface/class.

C# Code:
```
namespace DesignPattern
{
    public interface ITarget
    {
        string GetRequest();
    }

    // The Adaptee contains some useful behavior, but its interface is
    // incompatible with the existing client code. The Adaptee needs some
    // adaptation before the client code can use it.
    class Adaptee
    {
        public string GetSpecificRequest()
        {
            return "Specific request.";
        }
    }

    // The Adapter makes the Adaptee's interface compatible with the Target's
    // interface.
    class Adapter : ITarget
    {
        private readonly Adaptee _adaptee;

        public Adapter(Adaptee adaptee)
        {
            this._adaptee = adaptee;
        }

        public string GetRequest()
        {
            return $"This is '{this._adaptee.GetSpecificRequest()}'";
        }
    }
}

using DesignPattern;

Adaptee adaptee = new Adaptee();
ITarget target = new Adapter(adaptee);

Console.WriteLine("Adaptee interface is incompatible with the client.");
Console.WriteLine("But with adapter client can call it's method.");

Console.WriteLine(target.GetRequest());
```

### 2. Bridge

Purpose: Avoid multiple classes for combination objects like electric car etc. 
Instead an property object is kept in a class like electric engine in car etc.

C# Code:
```
namespace DesignPattern
{
    public interface IEngine
    {
        public string Refill();
    }

    public class ElectricEngine : IEngine
    {
        public string Refill()
        {
            return "Charged to 100%";
        }
    }

    public class PetrolEngine : IEngine
    {
        public string Refill()
        {
            return "Refilled with 5 litre";
        }
    }

    public abstract class IVehicle
    {
        protected IEngine engine;

        public IVehicle(IEngine engine)
        {
            this.engine = engine;
        }

        public abstract void Refill();
    }

    public class Car : IVehicle
    {
        public Car(IEngine engine):base(engine)
        {

        }

        public override void Refill()
        {
            Console.WriteLine("Car " + engine.Refill());
        }
    }

    public class Bike : IVehicle
    {
        public Bike(IEngine engine) : base(engine)
        {

        }

        public override void Refill()
        {
            Console.WriteLine("Bike " + engine.Refill());
        }
    }
}

using DesignPattern;

IVehicle car = new Car(new ElectricEngine());
car.Refill();

IVehicle bike = new Bike(new PetrolEngine());
bike.Refill();
```

### 3. Composite

Suppose there is a root folder which has many folders and files. All folders can have subfolders and files. 
If root folder size has to be determined, All its folder and file class should implement IFileSystemElement 
interface.
```
interface IFileSystemElement {
	int GetSize();
}
```
Folders will call its subfolders' and files' GetSize method.

### 4. Decorator

Purpose: Avoid multple class for combination of object. Instead implement addon classes.

C# Code:
```
namespace DesignPattern
{
    public interface IPizza
    {
        void Prepare();
    }

    public class BasePizza : IPizza
    {
        public void Prepare()
        {
            Console.WriteLine("Pizza prepared.");
        }
    }

    public abstract class PizzaDecorator : IPizza
    {
        IPizza pizza;

        public PizzaDecorator(IPizza pizza)
        {
            this.pizza = pizza;
        }
        public virtual void Prepare()
        {
            pizza.Prepare();
        }
    }

    public class PepperoniPizza : PizzaDecorator
    {
        public PepperoniPizza(IPizza pizza) : base(pizza)
        {
        }

        public override void Prepare()
        {
            
            Console.WriteLine("Pepperoni toppings added.");
            base.Prepare();
        }
    }

    public class CapsicumPizza : PizzaDecorator
    {
        public CapsicumPizza(IPizza pizza) : base(pizza)
        {
        }

        public override void Prepare()
        {
            Console.WriteLine("Capsicum toppings added.");
            base.Prepare();
        }
    }
}

using DesignPattern;

IPizza pizza = new CapsicumPizza(new PepperoniPizza(new BasePizza()));
pizza.Prepare();
```

## Behavioural Design Patterns

### 1. Chain of Responsibility

Purpose: Decouple all responsibility in several classes.

C# Code:
```
namespace DesignPattern
{
    public class Database
    {
        public Dictionary<string, string> users;

        public Database()
        {
            users = new Dictionary<string, string>
            {
                { "A", "1" },
                { "B", "2" },
                { "C", "3" }
            };
        }
    }
    public abstract class Handler
    {
        private Handler next;

        public Handler SetNextHandler(Handler next)
        {
            this.next = next;
            return next;
        }

        public abstract bool Handle(string username, string password);

        protected bool HandleNext(string username, string password)
        {
            if (next == null) return true;
            return next.Handle(username, password);
        }
    }

    public class UserExistsHandler : Handler
    {
        private Database database;
        public UserExistsHandler(Database database)
        {
            this.database = database;
        }

        public override bool Handle(string username, string password)
        {
            if(!database.users.ContainsKey(username)) {
                Console.WriteLine("User not exists.");
                return false;
            }
            Console.WriteLine("User exists.");
            return HandleNext(username, password);
        }
    }

    public class ValidPasswordHandler : Handler
    {
        private Database database;

        public ValidPasswordHandler(Database database)
        {
            this.database = database;
        }

        public override bool Handle(string username, string password)
        {
            if(!database.users.ContainsKey(username) || database.users[username] != password)
            {
                Console.WriteLine("Password does not match.");
                return false;
            }
            Console.WriteLine("Password does match.");
            return HandleNext(username, password);
        }
    }

    public class RollbackHandler : Handler
    {
        public RollbackHandler() { }

        public override bool Handle(string username, string password)
        {
            Console.WriteLine("Rollback successful.");
            return HandleNext(username, password);
        }
    }

    public class AuthService
    {
        private Handler handler;

        public AuthService(Handler handler)
        {
            this.handler = handler;
        }

        public bool Login(string username, string password)
        {
            if (handler.Handle(username, password))
            {
                Console.WriteLine("Authentication is successful.");
                return true;
            }
            Console.WriteLine("Authentication is failed.");
            return false;
        }
    }
}

using DesignPattern;

Database database = new Database();

Handler handler = new UserExistsHandler(database);
handler.SetNextHandler(new ValidPasswordHandler(database))
    .SetNextHandler(new RollbackHandler());

AuthService service = new AuthService(handler);
service.Login("B", "2");
```

### 2. Mediator

Purpose: Madiator is a communicator to communicate between different classes.

C# Code:
```
namespace DesignPattern
{
    public interface IMediator
    {
        void Notify(object sender, string ev);
    }

    // Concrete Mediators implement cooperative behavior by coordinating several
    // components.
    class ConcreteMediator : IMediator
    {
        private Component1 _component1;

        private Component2 _component2;

        public ConcreteMediator(Component1 component1, Component2 component2)
        {
            this._component1 = component1;
            this._component1.SetMediator(this);
            this._component2 = component2;
            this._component2.SetMediator(this);
        }

        public void Notify(object sender, string ev)
        {
            if (ev == "A")
            {
                Console.WriteLine("Mediator reacts on A and triggers following operations:");
                this._component2.DoC();
            }
            if (ev == "D")
            {
                Console.WriteLine("Mediator reacts on D and triggers following operations:");
                this._component1.DoB();
                this._component2.DoC();
            }
        }
    }

    // The Base Component provides the basic functionality of storing a
    // mediator's instance inside component objects.
    class BaseComponent
    {
        protected IMediator _mediator;

        public BaseComponent(IMediator mediator = null)
        {
            this._mediator = mediator;
        }

        public void SetMediator(IMediator mediator)
        {
            this._mediator = mediator;
        }
    }

    // Concrete Components implement various functionality. They don't depend on
    // other components. They also don't depend on any concrete mediator
    // classes.
    class Component1 : BaseComponent
    {
        public void DoA()
        {
            Console.WriteLine("Component 1 does A.");

            this._mediator.Notify(this, "A");
        }

        public void DoB()
        {
            Console.WriteLine("Component 1 does B.");

            this._mediator.Notify(this, "B");
        }
    }

    class Component2 : BaseComponent
    {
        public void DoC()
        {
            Console.WriteLine("Component 2 does C.");

            this._mediator.Notify(this, "C");
        }

        public void DoD()
        {
            Console.WriteLine("Component 2 does D.");

            this._mediator.Notify(this, "D");
        }
    }
}

using DesignPattern;

Component1 component1 = new Component1();
Component2 component2 = new Component2();
new ConcreteMediator(component1, component2);

Console.WriteLine("Client triggers operation A.");
component1.DoA();

Console.WriteLine();

Console.WriteLine("Client triggers operation D.");
component2.DoD();
```

### 3. Observer

Purpose: Update all subscribers to a particular event that they has already subscribed in.

C# Code:
```
namespace DesignPattern
{
    public interface IListener
    {
        public void Update();
    }
    public class EmailMessageListener : IListener
    {
        private string email;

        public EmailMessageListener(string email)
        {
            this.email = email;
        }

        public void Update()
        {
            Console.WriteLine("Email sent to " + email);
        }
    }

    public class MobileCallListener : IListener
    {
        private string mobile;

        public MobileCallListener(string mobile)
        {
            this.mobile = mobile;
        }

        public void Update()
        {
            Console.WriteLine("Call sent to " + mobile);
        }
    }

    public class NotificationService
    {
        private List<IListener> listeners;

        public NotificationService()
        {
            listeners = new List<IListener>();
        }

        public void Subscribe(IListener listener)
        {
            listeners.Add(listener);
        }
        
        public void Unsubscribe(IListener listener)
        {
            listeners.Remove(listener);
        }

        public void Notify()
        {
            listeners.ForEach(listener => listener.Update());
        }
    }

    public class Store
    {
        private NotificationService service;

        public Store()
        {
            service = new NotificationService();
        }

        public void NewItemPromotion()
        {
            service.Notify();
        }

        public NotificationService GetNotificationService()
        {
            return service;
        }
    }
}


using DesignPattern;

Store store = new Store();
store.GetNotificationService().Subscribe(new EmailMessageListener("RAFIQ"));
store.GetNotificationService().Subscribe(new EmailMessageListener("KARIM"));
store.GetNotificationService().Subscribe(new MobileCallListener("123"));
store.NewItemPromotion();
```

### 4. State

Purpose: Transition between different states of an object in a class. 

C# Code: (A = B = C = A)
```
namespace DesignPattern
{
    public class Phone
    {
        public State state;

        public Phone()
        {
            this.state = new StateA(this);
        }

        public void SetState(State state)
        {
            this.state = state;
        }

        public string GetMessageForGo()
        {
            return state.GetStateName() + " Go done.";
        }

        public string GetMessageForBack()
        {
            return state.GetStateName() + " Back done.";
        }
    }

    public abstract class State
    {
        protected string stateName;
        protected Phone phone;

        public State(string stateName, Phone phone)
        {
            this.phone = phone;
            this.stateName = stateName;
        }

        public string GetStateName()
        {
            return stateName;
        }
        public abstract string Go();
        public abstract string Back();
    }

    public class StateA : State
    {
        public StateA(Phone phone) : base("A", phone)
        {

        }

        public override string Back()
        {
            phone.SetState(new StateC(phone));
            return phone.GetMessageForBack();
        }

        public override string Go()
        {
            phone.SetState(new StateB(phone));
            return phone.GetMessageForGo();
        }
    }

    public class StateB : State
    {
        public StateB(Phone phone) : base("B", phone)
        {

        }

        public override string Back()
        {
            phone.SetState(new StateA(phone));
            return phone.GetMessageForBack();
        }

        public override string Go()
        {
            phone.SetState(new StateC(phone));
            return phone.GetMessageForGo();
        }
    }

    public class StateC : State
    {
        public StateC(Phone phone) : base("C", phone)
        {

        }

        public override string Back()
        {
            phone.SetState(new StateB(phone));
            return phone.GetMessageForBack();
        }

        public override string Go()
        {
            phone.SetState(new StateA(phone));
            return phone.GetMessageForGo();
        }
    }
}


using DesignPattern;

Phone phone = new Phone();
Console.WriteLine(phone.GetMessageForGo());
Console.WriteLine(phone.state.Go());
Console.WriteLine(phone.state.Go());
Console.WriteLine(phone.state.Back());
Console.WriteLine(phone.state.Go());
Console.WriteLine(phone.state.Go());
Console.WriteLine(phone.state.Go());
Console.WriteLine(phone.state.Go());
```

### 5. Strategy

Purpose: Decouple strategical responsibility in a class method.

C# Code:
```
namespace DesignPattern
{
    public interface PaymentStrategy
    {
        void CollectPaymentDetails();
        bool ValidatePaymentDetails();
        void Pay(int amount);
    }
    public class PaymentByCreditCard : PaymentStrategy
    {
        private string creaditCardNumber;

        public PaymentByCreditCard(string creaditCardNumber)
        {
            this.creaditCardNumber = creaditCardNumber;
        }

        public void CollectPaymentDetails()
        {
            Console.WriteLine("CreaditCardDetails entered.");
        }

        public bool ValidatePaymentDetails()
        {
            Console.WriteLine("CreditCardDetails validated.");
            return true;
        }

        public void Pay(int amount)
        {
            Console.WriteLine("Payment done " +  amount + " taka.");
        }
    }

    public class PaymentByPaypal : PaymentStrategy
    {
        private string paypalNumber;

        public PaymentByPaypal(string paypalNumber)
        {
            this.paypalNumber = paypalNumber;
        }

        public void CollectPaymentDetails()
        {
            Console.WriteLine("PaypalDetails entered.");
        }

        public bool ValidatePaymentDetails()
        {
            Console.WriteLine("PaypalDetails validated.");
            return true;
        }

        public void Pay(int amount)
        {
            Console.WriteLine("Payment done " + amount + " taka.");
        }
    }

    public class PaymentService
    {
        private int cost;
        private PaymentStrategy strategy;

        public void SetPaymentInfo(int cost, PaymentStrategy strategy)
        {
            this.cost = cost;
            this.strategy = strategy;
        }

        public void ProcessOrder()
        {
            strategy.CollectPaymentDetails();
            if(strategy.ValidatePaymentDetails())
            {
                strategy.Pay(cost);
            }
        }
    }
}

using DesignPattern;

PaymentService service = new PaymentService();
service.SetPaymentInfo(100, new PaymentByPaypal("123"));
service.ProcessOrder();
```
