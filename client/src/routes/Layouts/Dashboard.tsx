import { useQueryClient } from '@tanstack/react-query';
import { QueryKeys } from 'librechat-data-provider';
import { useEffect, useState } from 'react';
import { Outlet } from 'react-router-dom';
import { useAuthContext, usePreviousLocation } from '~/hooks';
import { DashboardContext } from '~/Providers';
import store from '~/store';

export default function DashboardRoute() {
  const queryClient = useQueryClient();
  const { isAuthenticated } = useAuthContext();
  const prevLocationRef = usePreviousLocation();
  const clearConvoState = store.useClearConvoState();
  const [prevLocationPath, setPrevLocationPath] = useState('');

  useEffect(() => {
    setPrevLocationPath(prevLocationRef.current?.pathname || '');
  }, [prevLocationRef]);

  useEffect(() => {
    queryClient.removeQueries([QueryKeys.messages, 'new']);
    clearConvoState();
  }, [queryClient, clearConvoState]);

  if (!isAuthenticated) {
    return null;
  }

  return (
    <DashboardContext.Provider value={{ prevLocationPath }}>
      <div className="h-screen w-full">
        <div className="fixed bottom-4 right-4 bg-green-500 text-white px-4 py-2 rounded-lg shadow-lg z-50">
          Deployed at {new Date().toLocaleString()}
        </div>
        <Outlet />
      </div>
    </DashboardContext.Provider>
  );
}
