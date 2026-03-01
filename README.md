# 📱 DemoDaraz

A Flutter e-commerce demo app that fetches products from **FakeStore API**.  
Supports **pinned tabs**, **single vertical scrolling**, and **pull-to-refresh** using a clean **sliver-based architecture**.

---

## Features

- Browse products by categories: All, Electronics, Jewelery  
- Smooth vertical scrolling with a pinned tab bar  
- Pull-to-refresh works from any tab  
- Sliver-based layout with a single scroll owner  
- Uses **Provider** for state management  

---

### Important Info
- Some functionality can be dupticated please ignore this.
- Limitation: In the current version, horizontal scrolling does not work alongside vertical scrolling. I believe it’s possible to handle both simultaneously, which is why I attempted to implement it using  ScrollController and TabController along with  mixin. However, due to a misunderstanding in the approach, the implementation wasn’t completed in time. I plan to revisit and implement this properly later.

### Run the App

```bash
flutter pub get
flutter run
