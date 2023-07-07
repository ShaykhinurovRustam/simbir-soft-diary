# Ежедневник

- Поддержка версий - iOS 12+
- UI написан с использованием Storyboard и Autolayout
- Архитектурный паттерн: MVVM
- Использование сторонних библиотек: SnapKit, Realm, RealmSwift (CocoaPods + SPM)
- Использование SwiftLint с кастомной конфигурацией

Пользователю при запуске приложения представлен календарь с возможностью выбора отображения дат (по месяцам и по неделям),
ниже календаря расположен временной интервал (от 00:00 до 23:00), где отображаются добавленные задания по времени.

<p float="left">
<img src="https://github.com/ShaykhinurovRustam/simbir-soft-diary/blob/e53690d483a640a17a51594df0f45abd1a0dfad0/AssetsForRepo/1.png" height="500">
<img src="https://github.com/ShaykhinurovRustam/simbir-soft-diary/blob/e53690d483a640a17a51594df0f45abd1a0dfad0/AssetsForRepo/2.png" height="500">
</p>

**Остальные скриншоты работы с ежедневником**
<p float="left"
<img src="https://github.com/ShaykhinurovRustam/simbir-soft-diary/blob/e53690d483a640a17a51594df0f45abd1a0dfad0/AssetsForRepo/3.png" height="500">
<img src="https://github.com/ShaykhinurovRustam/simbir-soft-diary/blob/e53690d483a640a17a51594df0f45abd1a0dfad0/AssetsForRepo/4.png" height="500">
<img src="https://github.com/ShaykhinurovRustam/simbir-soft-diary/blob/e53690d483a640a17a51594df0f45abd1a0dfad0/AssetsForRepo/5.png" height="500">
<img src="https://github.com/ShaykhinurovRustam/simbir-soft-diary/blob/e53690d483a640a17a51594df0f45abd1a0dfad0/AssetsForRepo/6.png" height="500">
</p>

Некоторые детали работы:
- Из-за ограниченности необходимого функционала UICalendarView, а также нежелания в использовании сторонних библиотек мной было принято решение написать собственный календарь и список задач с временным интервалом, с использованием UICollectionView и UITableView соответственно
- Верстка экран детального просмотра задачи была сделана с помощью IB, экран главного меню: IB + нативно, экран создания задачи: полностью с использованием SnapKit
