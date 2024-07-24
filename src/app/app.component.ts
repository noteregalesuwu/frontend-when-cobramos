import { Component } from '@angular/core';
import { RouterModule } from '@angular/router';
import { MatToolbarModule } from '@angular/material/toolbar';
import { MatIconModule } from '@angular/material/icon';
import { MatButtonModule } from '@angular/material/button';
import { MatCardModule } from '@angular/material/card';
import { LoaderComponent } from './shared/components/loader/loader.component';
import { LoaderService } from './shared/loader.service';
import { VisitorCountComponent } from './shared/components/visitor-count/visitor-count.component';
import { MatSidenavModule } from '@angular/material/sidenav';
import { MatSlideToggleModule } from '@angular/material/slide-toggle';
import { NgClass } from '@angular/common';

interface MenuItem {
  title: string;
  icon: string;
  route: string;
  isActive: boolean;
}

@Component({
  selector: 'app-root',
  standalone: true,
  imports: [
    RouterModule,
    MatToolbarModule,
    MatIconModule,
    MatButtonModule,
    MatCardModule,
    MatSidenavModule,
    LoaderComponent,
    VisitorCountComponent,
    MatSlideToggleModule,
    NgClass,
  ],
  templateUrl: './app.component.html',
  styleUrl: './app.component.css',
})
export class AppComponent {
  public theme: string = 'light';
  public menuItems: MenuItem[] = [
    {
      title: 'Inicio',
      icon: 'home',
      route: '/home',
      isActive: true,
    },
    {
      title: 'Sueldo',
      icon: 'money',
      route: '/sueldo',
      isActive: false,
    },
    {
      title: 'Aguinaldo',
      icon: 'money',
      route: '/aguinaldo',
      isActive: false,
    },
    {
      title: 'Memes',
      icon: 'mood',
      route: '/memes',
      isActive: false,
    },
    {
      title: 'Informaciones',
      icon: 'info',
      route: '/informaciones',
      isActive: false,
    },
  ];
  title = 'When cobramos';
  public isLoading = false;
  public currentRoute = '';
  constructor(private readonly loaderService: LoaderService) {
    this.loaderService.isLoading.subscribe((isLoading) => {
      this.isLoading = isLoading;
    });
  }

  public themeToggle(): void {
    this.theme = this.theme === 'light' ? 'dark' : 'light';
  }
}
