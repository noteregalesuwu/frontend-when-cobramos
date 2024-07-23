import { Routes } from '@angular/router';
import { HomeComponent } from './modules/home/home.component';
import { SueldoComponent } from './modules/sueldo/sueldo.component';
import { AguinaldoComponent } from './modules/aguinaldo/aguinaldo.component';
import { MemesComponent } from './modules/memes/memes.component';
import { InformacionesComponent } from './modules/informaciones/informaciones.component';
import { SugerenciasComponent } from './modules/sugerencias/sugerencias.component';

export const routes: Routes = [
  {
    path: 'home',
    pathMatch: 'full',
    component: HomeComponent,
  },
  {
    path: 'sueldo',
    pathMatch: 'full',
    component: SueldoComponent,
  },
  {
    path: 'aguinaldo',
    pathMatch: 'full',
    component: AguinaldoComponent,
  },
  {
    path: 'memes',
    pathMatch: 'full',
    component: MemesComponent,
  },
  {
    path: 'informaciones',
    pathMatch: 'full',
    component: InformacionesComponent,
  },
  {
    path: 'sugerencias',
    pathMatch: 'full',
    component: SugerenciasComponent,
  },
  {
    path: '**',
    pathMatch: 'full',
    loadComponent: () =>
      import('./modules/not-found/not-found.component').then(
        (m) => m.NotFoundComponent
      ),
  },
];
